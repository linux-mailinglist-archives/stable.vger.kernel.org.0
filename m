Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCC9455D141
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236481AbiF0PyX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 11:54:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236445AbiF0PyX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 11:54:23 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F4B626F1
        for <stable@vger.kernel.org>; Mon, 27 Jun 2022 08:54:22 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id a11so11524660ljb.5
        for <stable@vger.kernel.org>; Mon, 27 Jun 2022 08:54:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aGzvn0q0q9YA/Na0FGp2nMGFn59dA2Gv9fwVzm4epHQ=;
        b=lBJD4+VZ0kbkYmTliCpNDBnCjAZShf9B/HZkWqHsK8iJYouy5mxuL8mPSzyPh9NKaB
         0ibjLxvl41a78XCflD7VLmMChUqIRk9gussPPCuaUlTNaqrd/zzsr8qbJyA7+BwDSrQW
         Xt8HMSupt5qJ3S+ounN/0lbJ9MlnKNh+w1htShyC9Qt3SBqiXJ5WkxsGsIh1L5jlViXA
         m4zM7W9S80Emd/HyMwqii/mB/ygZ3VGqoVhS8haMsyOYbQ2zu9fmJbXWpuRkYoxwgvPr
         fVyZRYO9qVE2500TV+x7IUe21gZMZI3rqyLcceePnrDRvphkzeo3LhRGLAdzOsHVy528
         X+pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aGzvn0q0q9YA/Na0FGp2nMGFn59dA2Gv9fwVzm4epHQ=;
        b=rN/RpTgsHAixm5oIs5O8Ec3VbbmN6sW8KZUffYlAxOi/7ve12Q+KSiosJZfjpXuUEW
         o4nKmxrz6v5iQoCjbW+yrDlox50k2Mn8jpmNl2PHiGRTES+FK2jDFvkIiOpLqiQEJF6q
         oQTBNw5clM/QuO7Zl3q4X9dZ9D8s1HPwdjowIX+R9zWT1cgq7eSD3ZjdbSYEkx+0cQkV
         86VjPclcTNM2uHN39nBbRpFPiJIVsKafmeZvnEg35giqtYA/0Lr07KkVZHrMBs1KHa1w
         F/OFy0OAgG41ZNhxUF5zrajQq8o9T/J3jEimczvpfAIDAzlHhYPyAxtXB6ag+lRyjuFd
         avXw==
X-Gm-Message-State: AJIora/RG37BqUV72jBPW6kSBS/U1HXRmTfyK0x/OVO7dktA+36nfO5J
        lqj+FY0lKm3tBp8LQ0AkiIf04ju5GZHoyoh4xmkEazv/luvErw==
X-Google-Smtp-Source: AGRyM1vZblY+5ZvO7qMkFBibTMM6xaOo+us+0BH/P/EpAW9NZyMlLZgWth5IyDlvvuRZmwN423ildX/nqyTfL+k1gPE=
X-Received: by 2002:a2e:a801:0:b0:24a:ff0b:ae7a with SMTP id
 l1-20020a2ea801000000b0024aff0bae7amr7084748ljq.287.1656345260238; Mon, 27
 Jun 2022 08:54:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220627111944.553492442@linuxfoundation.org>
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
From:   Fenil Jain <fkjainco@gmail.com>
Date:   Mon, 27 Jun 2022 21:24:09 +0530
Message-ID: <CAHokDBmXcNXTo89qc-c3bW7KeJePx=m8XFQO_iGV59GfW45wAA@mail.gmail.com>
Subject: Re: [PATCH 5.18 000/181] 5.18.8-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Shuah Khan <skhan@linuxfoundation.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hey Greg,

Ran tests and boot tested on my system, no regression found

Tested-by: Fenil Jain <fkjainco@gmail.com>
