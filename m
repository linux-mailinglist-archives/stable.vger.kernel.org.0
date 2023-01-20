Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13784675C90
	for <lists+stable@lfdr.de>; Fri, 20 Jan 2023 19:18:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbjATSSN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Jan 2023 13:18:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230180AbjATSSK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Jan 2023 13:18:10 -0500
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B78F6FD04
        for <stable@vger.kernel.org>; Fri, 20 Jan 2023 10:18:09 -0800 (PST)
Received: by mail-ot1-x332.google.com with SMTP id t7-20020a05683014c700b006864760b1caso3583603otq.0
        for <stable@vger.kernel.org>; Fri, 20 Jan 2023 10:18:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XQ4uabPFxcoQm1QTLFZD9BxVTRSKlhmuv6WCzUO6WaQ=;
        b=KMgDLS5757jbjzGjW899tT1tEBToRQRfHS8FCCqYX35R51Vj5737iTqoTi5Y2+o1K6
         ndv6/srqmAxKqD6UcsrWuBXf6IYewI0MF9ZGp6df5ELtjmFL/lTjTMIDkUbzwQISeFaK
         1PAs3embRd6Aktss63+0pTdEyplMeh9rcnx3Ctgo9SbCowVOFiqbB9i8VrjXZXTUibMs
         FpE+N8O7+kH958x6b2KNDM5UQ57AgyE9Rka+XU0RLvXheJAE4Fccw4njD2SH58IBR6no
         X4PsdKpqlwr6bIQeNe/h0Ssfa4HKenV9Z0lN9cT7yE9dA5v9aWuXCJqlZYSeWAMEdmOm
         AQwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XQ4uabPFxcoQm1QTLFZD9BxVTRSKlhmuv6WCzUO6WaQ=;
        b=go1T2xJ2ZwlyeNbN7vLqKwI7pRfxgBfn4AweplrSPkhjB8Xqep4NLFRNiE4EYQorNy
         yVxl53ZTLPmhuAdwTfEu4yylT58v105mglzMokYMjqiDmZdDIL5Y5QgvmoqB3p+jXqUy
         hEc1pVPD1vnNR1dm7JtOhvY+M8z8xpPIhK8OC1ndIIlK8cXq/ZxeLdkgWu4+Ki+UYywk
         8gC1usbSJzCepURGV2bVrMnosvW7YVnpMyIGYU2GBxwG/eBFEq6mWtn7sWa24YWX3luh
         9apqgQQxDiXUHlqWKM9H+YNazikexLEYkE2jm2wKNUpNllkr0P1gXRoXfc2Y6fVCNxb6
         mSeQ==
X-Gm-Message-State: AFqh2krH/fBI1PNt9QR+00mkFqg7cms1ZZyFjc1q3IAlVt1j8f9btYEG
        +o/AyXcRdEdyjAYsnQ6dyg+2MXaJxFY=
X-Google-Smtp-Source: AMrXdXsRnYOtUAPLd55wUUUEzCAvNlj2J1+9X/g4Au5NCgrkEzwn9lHPX0+ZqJIsgGSQU/iwvc83oA==
X-Received: by 2002:a05:6830:169a:b0:684:e848:4593 with SMTP id k26-20020a056830169a00b00684e8484593mr7809357otr.32.1674238688753;
        Fri, 20 Jan 2023 10:18:08 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id cp17-20020a056830661100b00670763270fcsm21773109otb.71.2023.01.20.10.18.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jan 2023 10:18:08 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 20 Jan 2023 10:18:06 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     "Limonciello, Mario" <mario.limonciello@amd.com>
Cc:     Wayne Lin <Wayne.Lin@amd.com>, dri-devel@lists.freedesktop.org,
        amd-gfx@lists.freedesktop.org, stable@vger.kernel.org,
        stanislav.lisovskiy@intel.com, Fangzhi Zuo <Jerry.Zuo@amd.com>,
        bskeggs@redhat.com
Subject: Re: [PATCH] Revert "drm/display/dp_mst: Move all payload info into
 the atomic state"
Message-ID: <20230120181806.GA890663@roeck-us.net>
References: <20230112085044.1706379-1-Wayne.Lin@amd.com>
 <20230120174634.GA889896@roeck-us.net>
 <a9deecb3-5955-ee4e-c76f-2654ee9f1a92@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a9deecb3-5955-ee4e-c76f-2654ee9f1a92@amd.com>
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

Hi Mario,

On Fri, Jan 20, 2023 at 11:51:04AM -0600, Limonciello, Mario wrote:
> On 1/20/2023 11:46, Guenter Roeck wrote:
> > On Thu, Jan 12, 2023 at 04:50:44PM +0800, Wayne Lin wrote:
> > > This reverts commit 4d07b0bc403403438d9cf88450506240c5faf92f.
> > > 
> > > [Why]
> > > Changes cause regression on amdgpu mst.
> > > E.g.
> > > In fill_dc_mst_payload_table_from_drm(), amdgpu expects to add/remove payload
> > > one by one and call fill_dc_mst_payload_table_from_drm() to update the HW
> > > maintained payload table. But previous change tries to go through all the
> > > payloads in mst_state and update amdpug hw maintained table in once everytime
> > > driver only tries to add/remove a specific payload stream only. The newly
> > > design idea conflicts with the implementation in amdgpu nowadays.
> > > 
> > > [How]
> > > Revert this patch first. After addressing all regression problems caused by
> > > this previous patch, will add it back and adjust it.
> > 
> > Has there been any progress on this revert, or on fixing the underlying
> > problem ?
> > 
> > Thanks,
> > Guenter
> 
> Hi Guenter,
> 
> Wayne is OOO for CNY, but let me update you.
> 
> Harry has sent out this series which is a collection of proper fixes.
> https://patchwork.freedesktop.org/series/113125/
> 
> Once that's reviewed and accepted, 4 of them are applicable for 6.1.

Thanks a lot for the update. There is talk about abandoning v6.1.y as
LTS candidate, in large part due to this problem, so it would be great
to get the problem fixed before that happens.

Thanks,
Guenter
