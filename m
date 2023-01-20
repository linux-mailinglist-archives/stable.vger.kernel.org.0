Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 301AC675BE7
	for <lists+stable@lfdr.de>; Fri, 20 Jan 2023 18:46:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbjATRql (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Jan 2023 12:46:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbjATRqj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Jan 2023 12:46:39 -0500
Received: from mail-oa1-x35.google.com (mail-oa1-x35.google.com [IPv6:2001:4860:4864:20::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49854518D1
        for <stable@vger.kernel.org>; Fri, 20 Jan 2023 09:46:38 -0800 (PST)
Received: by mail-oa1-x35.google.com with SMTP id 586e51a60fabf-142b72a728fso6991589fac.9
        for <stable@vger.kernel.org>; Fri, 20 Jan 2023 09:46:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hUvUA2IIr3qtMnOvBvL5zQt24HHkmc2C85O4j7dXdfU=;
        b=i3bO+kPprrkq3bNt7btyN6LWwl4miHQ7RE8ySv8ircxiwhR7SB2yHxjuyS9/VgUp9H
         NvRVDLhgOcUZivlnJE5bZkekhw3Ye4ajaNqbuKh0d3oyd1kmPWUpAFlSIZfjYEuvJAxt
         FLcb5wIc/evmZOhM4yH4gCoWbOhV/9Zz3wz3qB2d4uxw8sWr6mjXwoXzLguXJ1cmIkhU
         pcMuXKqi8tn+wn0eUMuhQi/t5F/Km/mO6xp2vwSVOTeDafxJokeSiNyP9brfqfY5b19t
         nUmw+HhZg+uC8Y3jYHwxmDQMRW4egVvoPAFPsPCJQhlRODFcVh+yTQrffuuR5aH1wN60
         /nRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hUvUA2IIr3qtMnOvBvL5zQt24HHkmc2C85O4j7dXdfU=;
        b=eHav5lYDwRPtXG4iAQT2VpnoGDSfhz090nw/dOjZsBb3QcpVjHzit1I1tuuJbZtsrR
         eAIjXnhRT4/Gd0u81UI/TR0rXnLmWw+l6qm5wXDF6lJtZ+w/wWawqDJUTnB45rX6/1X3
         VfYO3TKtfoLhe5zuo8wMTrb2x76kpZaP2zpbB8a1ZgzrwrpgS7VaJ98UwssnkkyA3lte
         Asd2+p9Pz62JrSi6W7DT7JUIFV6LlBBY+77gHZmJ2/mmBJ/7dWVYOWuiPQxu3tLBqtdt
         V7C8vT6u8NfkoFqQn+SaGEgpI+8aH1ifIvo/6K0tn2iJcoJMVSavTDrpRTCGF9hLuuEz
         5yww==
X-Gm-Message-State: AFqh2kpiOZpPATxLSmcVWsFHQ9dBfvmARsUPCNqPrkVHlZWhPQlrM7LV
        9K4QGqNWBoynKuqsSN/QmoEDQT3qsk8=
X-Google-Smtp-Source: AMrXdXs3gWMMWtehBRolAqaRrPB1xApkqkraSR4LaVvXxomzpHUftM+HKwaGNiCVay5j9fehIgQsPA==
X-Received: by 2002:a05:6870:c20b:b0:15f:1bd4:6f67 with SMTP id z11-20020a056870c20b00b0015f1bd46f67mr9524957oae.29.1674236797477;
        Fri, 20 Jan 2023 09:46:37 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o41-20020a056870912900b0015f9cc16ef7sm3513480oae.46.2023.01.20.09.46.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jan 2023 09:46:36 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 20 Jan 2023 09:46:34 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Wayne Lin <Wayne.Lin@amd.com>
Cc:     dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
        stable@vger.kernel.org, stanislav.lisovskiy@intel.com,
        Fangzhi Zuo <Jerry.Zuo@amd.com>, mario.limonciello@amd.com,
        bskeggs@redhat.com
Subject: Re: [PATCH] Revert "drm/display/dp_mst: Move all payload info into
 the atomic state"
Message-ID: <20230120174634.GA889896@roeck-us.net>
References: <20230112085044.1706379-1-Wayne.Lin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230112085044.1706379-1-Wayne.Lin@amd.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 12, 2023 at 04:50:44PM +0800, Wayne Lin wrote:
> This reverts commit 4d07b0bc403403438d9cf88450506240c5faf92f.
> 
> [Why]
> Changes cause regression on amdgpu mst.
> E.g.
> In fill_dc_mst_payload_table_from_drm(), amdgpu expects to add/remove payload
> one by one and call fill_dc_mst_payload_table_from_drm() to update the HW
> maintained payload table. But previous change tries to go through all the
> payloads in mst_state and update amdpug hw maintained table in once everytime
> driver only tries to add/remove a specific payload stream only. The newly
> design idea conflicts with the implementation in amdgpu nowadays.
> 
> [How]
> Revert this patch first. After addressing all regression problems caused by
> this previous patch, will add it back and adjust it.

Has there been any progress on this revert, or on fixing the underlying
problem ?

Thanks,
Guenter
