Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D422A43FCE
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:01:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731559AbfFMQAW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:00:22 -0400
Received: from mail-yw1-f66.google.com ([209.85.161.66]:39350 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731467AbfFMItP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 04:49:15 -0400
Received: by mail-yw1-f66.google.com with SMTP id u134so8022590ywf.6;
        Thu, 13 Jun 2019 01:49:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=I6UyaxSTDYC3Nw7IhcYs4/PyOHgAItjqEtzyzOVUKhk=;
        b=slONmf1yqrVX8PMrx2uq4Bgn5UU1CVkUW4OZ1XQYASlIKQ23pIF2NQuLSFDlgjyN45
         UVACN1aiwC7pjWRe7xfFyJHx/Ap8+0ph68whxCDYj7luyQV9TrYtDYbkfWekK6Td0t9+
         Cp7ixW//uTSzFllMQc9vw83A0iFhSjzB2lB3dkndSry0ZlcCGlbmi9TqLiUE1S73YaQk
         PAjgL0iPg58ARZsUfBqx/SGdGtz9lNEJkpw/EJrVMsjuYHf+Wb9/dx4TNaTX0avHP7hY
         jrsUFiksZXNOFom9xwynV3qI1tZZTkhother77vHEMeqUFcPnmy4BLrXkvhuCFcZ1aGD
         ixMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=I6UyaxSTDYC3Nw7IhcYs4/PyOHgAItjqEtzyzOVUKhk=;
        b=WEdYe5B79xSVnebASMiL1dv6d/c3TNniAwhcNCb1HRJw9HoC5JN3pUbp3e4EHBcNEa
         kLMpmTcB+Y/mpOXn8i9qF0YZj0ekPQiXJjhoBW6k0nleyzFV7cjauVyqJ2feR3pSQQuI
         cYnK0U5GPqJl14AoAVuEtpxuzrzuWo5vp0dd1PxS+VStZgbiOtx1jA0kzaOQGfLj3Xrp
         t891ApN6c+K0vhRs2uAdGHqcxiAHhNt8dDjwa2x8KDX+vi7Oq3HlvDMRTlbfvWa2tEE6
         17jNPKqqW6OaM55e/bhvBiJxIEICm0AKmefFO3vif5Bt3GxNkP4evaE290ZYEE9rm/ED
         tt7A==
X-Gm-Message-State: APjAAAWq9VyAbGWzxfwX3uXglpsk5vbwgSoBvbSsytHZoptV3pAcJxtt
        0FBAPQ16lIUUi42G2ExlP5w9tQPKJrtLa+Gw+m0=
X-Google-Smtp-Source: APXvYqzDL99aqzhjQhwcXHhqZm2FcTLdY5l71zUGcskHDGLuZFqPZPymeJE0mVgbMel0G6UAftYz17Iiz1Mq+uuX0xI=
X-Received: by 2002:a81:910a:: with SMTP id i10mr32625206ywg.31.1560415754953;
 Thu, 13 Jun 2019 01:49:14 -0700 (PDT)
MIME-Version: 1.0
References: <1560073529193139@kroah.com>
In-Reply-To: <1560073529193139@kroah.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 13 Jun 2019 11:49:03 +0300
Message-ID: <CAOQ4uxiTrsOs3KWOxedZicXNMJJharmWo=TDXDnxSC1XMNVKBg@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] ovl: support the FS_IOC_FS[SG]ETXATTR
 ioctls" failed to apply to 5.1-stable tree
To:     Greg KH <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Miklos Szeredi <mszeredi@redhat.com>,
        stable <stable@vger.kernel.org>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jun 9, 2019 at 12:45 PM <gregkh@linuxfoundation.org> wrote:
>
>
> The patch below does not apply to the 5.1-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
>
> thanks,
>
> greg k-h
>

FYI, the failure to apply this patch would be resolved after you
picked up "ovl: check the capability before cred overridden" for
stable, please hold off from taking this patch just yet, because
it has a bug, whose fix wasn't picked upstream yet.

Thanks,
Amir.
