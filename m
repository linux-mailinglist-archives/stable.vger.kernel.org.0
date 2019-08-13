Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC8048BC25
	for <lists+stable@lfdr.de>; Tue, 13 Aug 2019 16:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729586AbfHMOyJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 10:54:09 -0400
Received: from mail-yb1-f195.google.com ([209.85.219.195]:34717 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729404AbfHMOyJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Aug 2019 10:54:09 -0400
Received: by mail-yb1-f195.google.com with SMTP id q5so27937475ybp.1
        for <stable@vger.kernel.org>; Tue, 13 Aug 2019 07:54:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1KU9mje70e+6lKi+rMvXi2qXDx/1Q5yRIVbPscoGXPM=;
        b=h2ukMp8EPMkBgpIyyFxOgCduzQ3gQstydJDnvvMifx8yP8rJ2dG9GZ1x/yiAVJ6uu4
         2KGThU8AfrzAQqyCHPSHdZOy8WnmUJ43QM+7a/HL1u1GN9tvmiA9hEiDJBLzZi2luoYK
         yXPNHTf+Z/kJ6n/LGkEJyXFQc9bLFQqmtVL/iZOhnc9rUQbGrsSfz5taksMS3bcEl4cJ
         tJIw0cMVUCyBbd9m6bSdntaaFaQwIxp4+K58HEHnvxaDiyg1z/HLtN5Jz7mtkxhbBc4b
         WsX9fQF/oypxcHm+j66KAgiMfnnyPXXLEIG9oxp5eLgtMCbx7yjM2QjcALIYeb3Xy70E
         c2HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1KU9mje70e+6lKi+rMvXi2qXDx/1Q5yRIVbPscoGXPM=;
        b=K+o5bn6rFzSNej++9HNzcVeLIPc9K4tkaEyOcT/u+5fNBd4q32fgrN3DwN36KmkqHo
         msmljtTHlCdq0t16EqrQnhd6HsP0pRdR+Af3lZqnHyfkj6GQessPyWOMY/uHCKP8GhkV
         ZyU7ryfQaVtG66bbG4oORBEcxzrvQshLazkAib/VWJx9Gxn7uMRkQh5zqHx9qJeiAkUH
         4rTbj+hnV7m37qvrKAUR2+Qa8+GouoYHIOy8D024ySlTffqG8JKF1rXIlp45qVsjkwXN
         cy7S6tnNXIAjeebyuHB23I3VFwn2mYKZYCgqhdXit1D8M2xKk6WfJmuytlpPyp7tr7V4
         LQpw==
X-Gm-Message-State: APjAAAXws0UpZSR4zRBZPstbCg41Q7+dyQCSDmPts3o9haUPjYM6e8v2
        DB/HP2ZYZ5tAGf4xAehXrHwUnJVClm6pzLKK9lY=
X-Google-Smtp-Source: APXvYqzTiFoZxKA6/w46nHrRRZNZR7l/RR8F8w5xde/qo5FAy4WJMIytp6bjq8QMDOMdBbsqhP3SyXTD8emi1H7HPkk=
X-Received: by 2002:a5b:5ce:: with SMTP id w14mr7416427ybp.25.1565708048859;
 Tue, 13 Aug 2019 07:54:08 -0700 (PDT)
MIME-Version: 1.0
References: <20190812220847.14624-1-jcmvbkbc@gmail.com> <20190813124815.D64A520840@mail.kernel.org>
In-Reply-To: <20190813124815.D64A520840@mail.kernel.org>
From:   Max Filippov <jcmvbkbc@gmail.com>
Date:   Tue, 13 Aug 2019 07:53:57 -0700
Message-ID: <CAMo8Bf+AAo0+4yriZv-RpGHchAODJ5y1-jFGvYbJcBx958dkSA@mail.gmail.com>
Subject: Re: [PATCH] xtensa: add missing isync to the cpu_reset TLB code
To:     Sasha Levin <sashal@kernel.org>
Cc:     "open list:TENSILICA XTENSA PORT (xtensa)" 
        <linux-xtensa@linux-xtensa.org>, Chris Zankel <chris@zankel.net>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

On Tue, Aug 13, 2019 at 5:48 AM Sasha Levin <sashal@kernel.org> wrote:
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: all
>
> The bot has tested the following trees: v5.2.8, v4.19.66, v4.14.138, v4.9.189, v4.4.189.
>
> v5.2.8: Build OK!
> v4.19.66: Build OK!
> v4.14.138: Build OK!
> v4.4.189: Failed to apply! Possible dependencies:
>     4f2056873ff0 ("xtensa: extract common CPU reset code into separate function")
>     bf15f86b343e ("xtensa: initialize MMU before jumping to reset vector")
>     ea951c34ea95 ("xtensa: fix icountlevel setting in cpu_reset")
>
>
> NOTE: The patch will not be queued to stable trees until it is upstream.
>
> How should we proceed with this patch?

It should be applied to stable trees for linux versions 4.10 and newer.

-- 
Thanks.
-- Max
