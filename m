Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4888E6D3FC9
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 11:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231310AbjDCJNp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 05:13:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231285AbjDCJNo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 05:13:44 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 756F65B8B
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 02:13:43 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id x3so114388227edb.10
        for <stable@vger.kernel.org>; Mon, 03 Apr 2023 02:13:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680513222;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pgIXEaT2+H6gQyFiw35tSG63XK4qxQI/gI/Cz+46yBE=;
        b=micKzf6PfBiNY9fSijQfbYNv9swhQe1WSN3VgT9CTm3yDoz4DqGtj3c5YXYplq5DK8
         bWVaLGO59bC/zuyK2v5Weh6NDEDlEyuOzh/okW19thY1gtDwCCGC6gu10SQ590r35vK6
         a97zB93I7AeDSOcIs0dKTaGrOSh1awL6TSXW0T+A0y5xXB4XzsfoEhkb4P/P39AcvMYz
         LJkjRE999ale30EKCcu1qEAt76AGEtq0QDF8ZS9yEEz+8MTkCx1PLfdpVJ8PITWHrRG6
         Pov0cujeKOoy75bu9DGxbpzS8u0L9wmoyelWgd+Fr50inzAhWdAUC+pjWZE8PttE1VfW
         RGrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680513222;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pgIXEaT2+H6gQyFiw35tSG63XK4qxQI/gI/Cz+46yBE=;
        b=0F0m0eeHGjdZKUGDXwESwBbYuunvcI0tfZLX+Ncvp0KLHToQ2zNimCrZ/QnirCl5TP
         XN5i7wTNFkeTfL7ISMhPn09EInb0UJFNN7WvH2x7OqpHA0DV6iy/Nv3N8ZBhKgTAWCQK
         XYJVA06M01OCYShh4eEQI2C6yQ0nGpvhEchOUYfyrok68cH/d3lEXZwsfonWct1vu1PF
         iAtK7syeQKSgPDHjWa0WtDP37ptQB9TMxsAq4LDHrlmBxlybV74L1mKdzWkZF117eiM+
         hBgz1CZYJ8C7xvxnd+0D7cEC6AVN8gfWPvnkAeZOrYxgoae+9AaHXT0CcsVO85X/Xd2+
         tO9g==
X-Gm-Message-State: AAQBX9flWs7BzxmYFqk82iy/fsv3rb+ZdDleaK8g30IcKNH2knnUiN8z
        pGU99uEaR8d9SkVFbAX6yps=
X-Google-Smtp-Source: AKy350Y0VqiU2PKD212i5Bq4IAjPQ4g/VsiKiyWy4Dhf72DhBYoVu0T58Qnq3lTXaf7dE4tFNibotg==
X-Received: by 2002:a17:906:cc5b:b0:930:9cbd:4e88 with SMTP id mm27-20020a170906cc5b00b009309cbd4e88mr34467369ejb.8.1680513221880;
        Mon, 03 Apr 2023 02:13:41 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id g17-20020a1709064e5100b009312cc428e4sm4242904ejw.165.2023.04.03.02.13.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 02:13:41 -0700 (PDT)
Date:   Mon, 3 Apr 2023 12:13:38 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Cc:     lgirdwood@gmail.com, broonie@kernel.org,
        alsa-devel@alsa-project.org, pierre-louis.bossart@linux.intel.com,
        ranjani.sridharan@linux.intel.com, kai.vehmanen@linux.intel.com,
        guennadi.liakhovetski@linux.intel.com, stable@vger.kernel.org
Subject: Re: [PATCH for v6.3-rc] ASoC: SOF: ipc4-topology: Clarify bind
 failure caused by missing fw_module
Message-ID: <0ad876e9-761e-4cca-a955-99c6a7f710f5@kili.mountain>
References: <20230403090909.18233-1-peter.ujfalusi@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230403090909.18233-1-peter.ujfalusi@linux.intel.com>
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 03, 2023 at 12:09:09PM +0300, Peter Ujfalusi wrote:
> The original patch uses a feature in lib/vsprintf.c to handle the invalid
> address when tring to print *_fw_module->man4_module_entry.name when the
> *rc_fw_module is NULL.
> This case is handled by check_pointer_msg() internally and turns the
> invalid pointer to '(efault)' for printing but it is hiding useful
> information about the circumstances. Change the print to emmit the name
> of the widget and a note on which side's fw_module is missing.
> 
> Fixes: e3720f92e023 ("ASoC: SOF: avoid a NULL dereference with unsupported widgets")
> Reported-by: Dan Carpenter <error27@gmail.com>
> Link: https://lore.kernel.org/alsa-devel/4826f662-42f0-4a82-ba32-8bf5f8a03256@kili.mountain/
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
> ---

Thanks!

regards,
dan carpenter

