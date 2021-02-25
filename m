Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0A3C325A34
	for <lists+stable@lfdr.de>; Fri, 26 Feb 2021 00:32:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbhBYXcE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 18:32:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbhBYXcE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Feb 2021 18:32:04 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C57BCC061574
        for <stable@vger.kernel.org>; Thu, 25 Feb 2021 15:31:23 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id b21so697257eja.4
        for <stable@vger.kernel.org>; Thu, 25 Feb 2021 15:31:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IRgJvK9HYgFm3AnvCuaph7Yp3iy7hYcD/wHZO+dmupo=;
        b=GNnCPDWTAZLzzRedOt1+E+XN0Jjf4vPf8kXc05j5ewoHtM1IHCzIlm9ssJlmLH+P3w
         bOEtqaLdlAPMfXBQWiJEURLJnjhVypTG95JV40AQq3nwrm0RcsNdteN6hKhsZvcYjs/W
         8rA9L+JnQ7tCzn/96N8Fa3bJcV3SCis1NpzeDyHWSD+uHWeELdySdh1fxzRaEBWLF6tW
         +crP9/erVAtfKIfHL/ul3slQ+mD8ByhW9lq5BeUVJf01hpoTxSlEBLpGv0y0ls6AxM92
         6Ld3xcx2d9P8087gyor5f/0I6aKps7fjsC7d9+zzJxIXtmRA0j1WFsXz84Vr7PxX3jeQ
         K1Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IRgJvK9HYgFm3AnvCuaph7Yp3iy7hYcD/wHZO+dmupo=;
        b=ayTTWWPxaoVVrVsL3ywm7l4Th1NXi8mnvHaYT8IsKqWqO8OXELnOtA0Io+XIKdFOvc
         UIGQSP/umsg0jnDAYFFCeBZUih4PiHRYgAIxqRodOkn8Rmjjm8I+Yi0fhBlwnE6YvGcd
         hx0LonKzUconHSAZ0UqVaAWnAnAdbuwy4Sx3fXtLahTJ5xVxgiWkp+JTfdHrTC7Zxh8p
         IdmeTmJTgqXKZBBo8i/SIygHHyqKSnslQQCuZR8/Vi6EDRIDhetFAT6gi72I59Lx2qTC
         bnkGHuZxTSIeWvq7lrSS5ZpEk4ahUc6fUnwzDSQBcBZA0U2LLKj8KZ9ZY2uD2iZXFQXt
         SAFQ==
X-Gm-Message-State: AOAM532WSRomsj6DT1j0gRrMy1vAl4xPfSCgaDUwmbA1YEqZqdkv0/iX
        YULwJA5xOtwbuGChy3S2QG9YFlNDjvUWToVeNsf9ug==
X-Google-Smtp-Source: ABdhPJwOIAU1i42WFqQFQGOCoOFAfSQetnEpfgNAkboGpau0rdPRz6MUuo/GXP9PWxUUjgwIAJIF0J8dNL3wZWIgMKE=
X-Received: by 2002:a17:906:ae88:: with SMTP id md8mr75648ejb.264.1614295882579;
 Thu, 25 Feb 2021 15:31:22 -0800 (PST)
MIME-Version: 1.0
References: <1612779897191109@kroah.com> <YDgVYCKzK8zNt3Jy@debian>
In-Reply-To: <YDgVYCKzK8zNt3Jy@debian>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Thu, 25 Feb 2021 15:31:19 -0800
Message-ID: <CAPcyv4iD3p4O8YAV1R=orLXrCohHT4uRA54ac2LMD_Q=ds08uA@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] libnvdimm/dimm: Avoid race between probe
 and" failed to apply to 4.19-stable tree
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>, Coly Li <colyli@suse.com>,
        Dave Jiang <dave.jiang@intel.com>,
        "Weiny, Ira" <ira.weiny@intel.com>,
        Richard Palethorpe <rpalethorpe@suse.com>,
        stable <stable@vger.kernel.org>,
        Vishal L Verma <vishal.l.verma@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 25, 2021 at 1:24 PM Sudip Mukherjee
<sudipm.mukherjee@gmail.com> wrote:
>
> Hi Greg,
>
> On Mon, Feb 08, 2021 at 11:24:57AM +0100, gregkh@linuxfoundation.org wrote:
> >
> > The patch below does not apply to the 4.19-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
>
> Here is the backport. Will apply to all branches till 4.4-stable.

Backport looks good to me. Thanks Sudip!
