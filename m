Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B00E065D5CC
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 15:35:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239538AbjADOfV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 09:35:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239556AbjADOfT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 09:35:19 -0500
Received: from mail-oa1-x2c.google.com (mail-oa1-x2c.google.com [IPv6:2001:4860:4864:20::2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B6BE39FBF;
        Wed,  4 Jan 2023 06:35:15 -0800 (PST)
Received: by mail-oa1-x2c.google.com with SMTP id 586e51a60fabf-14fb3809eaeso34051467fac.1;
        Wed, 04 Jan 2023 06:35:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zB+vRGMvvASIB5FujPNRSjnu/+QE/GLU5nqwmEXwDCk=;
        b=mGKZXEGIWCYErVLo5gZNoIHd62FHkktA36fKyP2jKsCZWJZ7biZepb8vtiQ/v/B3HY
         MM//PuBNKbeGhf8htKi4KsxYY+L+RzLyYbUSczkTaIoyhy60pqqOIo6/jjiwNKm69F8v
         PwrP4w8oIWa5BWCqwasZMrf1Xj0ctq8Oic9T1583P5XpMWFSol5pGOPk14mhNJGxBV9G
         rHc7aPg5glTmL3undODJcJvij81q1GHzh1bp5uIvp5NimvarjU5R9DAyaM0FCI8cvIMG
         Yx+yBeUGSFK2IBnlODPCrz3SqF8OuVcEWoeNP6z+/uRqX+nNRbwT/C8Tj972pdyDo8Nl
         iKhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zB+vRGMvvASIB5FujPNRSjnu/+QE/GLU5nqwmEXwDCk=;
        b=Z99IocEJhpYhIQiARFkuIry9zBT+Prc6/PxYmtFTG7v8TbweU2WP+BIi9Ga664/V4i
         2ev4ER0jZ2CDhdX9KBDAZ3CoRGXE4hEo841jzJpo6g/DsxhnK1EquTDMLtXStQq6GycY
         bF1QV3i/N0UZsgWQxSqCGVwpjGq2yiC66xA6U6TMs0CI1RW7nJGhYvYS7CUXXbOiZFGq
         VRvi7rCyX5XwgWOnoXWb/4/hX5hB45I7f+BLwxNkhb1YsxwiIRpVJ6q0N+TzTOD13Lbm
         XcoMkfEoOZmeAHYuHgb4Y6rqKOPdNxY6XSUUVjRO/fCPXLuk4bZhckxc/ninWv+bCCrc
         u5KQ==
X-Gm-Message-State: AFqh2kqRDxeCjBGFda9XYLJ/jDkKwlr4hZBD6hc64iqSNVF8NuaaHITo
        EpVKlCSuSqgClMu9YgTt0wkz+HJcpEIgh/PaZ9o=
X-Google-Smtp-Source: AMrXdXthZjoFH2Z/y+TKvd6b7bmn6ZTqN4X5a6sl/E9Q/d2q2OP73JbqQWqOvQAkSsrPczN5keTwc53e1FiR9xp4BWg=
X-Received: by 2002:a05:6870:c59c:b0:150:d9aa:4011 with SMTP id
 ba28-20020a056870c59c00b00150d9aa4011mr466653oab.96.1672842914879; Wed, 04
 Jan 2023 06:35:14 -0800 (PST)
MIME-Version: 1.0
References: <20230103184308.511448-1-dragos.panait@windriver.com>
 <20230103184308.511448-2-dragos.panait@windriver.com> <Y7Vz8mm0X+1h844b@kroah.com>
 <a8c6859f-5876-08cf-5949-ecf88e6bb528@amd.com>
In-Reply-To: <a8c6859f-5876-08cf-5949-ecf88e6bb528@amd.com>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Wed, 4 Jan 2023 09:35:03 -0500
Message-ID: <CADnq5_Ons+yMyGxcSaFaOb5uNXooHgH_4N=ThHOGYaW9Pb_Q8A@mail.gmail.com>
Subject: Re: [PATCH 4.19 1/1] drm/amdkfd: Check for null pointer after calling kmemdup
To:     =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Dragos-Marian Panait <dragos.panait@windriver.com>,
        Oded Gabbay <oded.gabbay@gmail.com>,
        David Zhou <David1.Zhou@amd.com>,
        amd-gfx@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        Alex Deucher <alexander.deucher@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 4, 2023 at 8:23 AM Christian K=C3=B6nig <christian.koenig@amd.c=
om> wrote:
>
> Am 04.01.23 um 13:41 schrieb Greg KH:
> > On Tue, Jan 03, 2023 at 08:43:08PM +0200, Dragos-Marian Panait wrote:
> >> From: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> >>
> >> [ Upstream commit abfaf0eee97925905e742aa3b0b72e04a918fa9e ]
> >>
> >> As the possible failure of the allocation, kmemdup() may return NULL
> >> pointer.
> >> Therefore, it should be better to check the 'props2' in order to preve=
nt
> >> the dereference of NULL pointer.
> >>
> >> Fixes: 3a87177eb141 ("drm/amdkfd: Add topology support for dGPUs")
> >> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> >> Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
> >> Signed-off-by: Felix Kuehling <Felix.Kuehling@amd.com>
> >> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> >> Signed-off-by: Dragos-Marian Panait <dragos.panait@windriver.com>
> >> ---
> >>   drivers/gpu/drm/amd/amdkfd/kfd_crat.c | 3 +++
> >>   1 file changed, 3 insertions(+)
> > For obvious reasons, I can't take a patch for 4.19.y and not newer
> > kernel releases, right?
> >
> > Please provide backports for all kernels if you really need to see this
> > merged.  And note, it's not a real bug at all, and given that a CVE was
> > allocated for it that makes me want to even more reject it to show the
> > whole folly of that mess.
>
> Well as far as I can see this is nonsense to back port.
>
> The code in question is only used only once during driver load and then
> never again, that exactly this allocation fails while tons of other are
> made before and after is extremely unlikely.
>
> It's nice to have it fixed in newer kernels, but not worth a backport
> and certainly not stuff for a CVE.

It's already fixed in Linus' tree:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
id=3Dabfaf0eee97925905e742aa3b0b72e04a918fa9e

Alex

>
> Regards,
> Christian.
>
>
> >
> > thanks,
> >
> > greg k-h
>
