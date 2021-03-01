Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF62B3289A7
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:03:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238921AbhCASCX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:02:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238690AbhCARz0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 12:55:26 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02FFCC061756
        for <stable@vger.kernel.org>; Mon,  1 Mar 2021 09:54:45 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id o11so10787756iob.1
        for <stable@vger.kernel.org>; Mon, 01 Mar 2021 09:54:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HcRiho973ngZafEIJab/gwLURlQ36AyAGmDbM50FuA4=;
        b=RPGpITPwX1K+QSNB2EUUe2ZQTI3n0tLbrTTqtX8XzkiNzDSE24qPjZSdsNtmfPj4OB
         9hESdJv/uZPv046FtTKYrTh76U9xmk3bB02tc4LXNRTKeUg7HQYJLWEwRhAOMiWaMdFI
         xTRXIXC7xruq8g0sKNZBHdq4Bc8SO2wx8m2RTspTAFfh+HGeJMhYZvmjFy4O5WyhW2Cw
         qlIkmFkfjmaJD7D2WI+Pmvp/W1pVsZXQpIWL5l2873PsoTH4X9WtVk/QDxoS2MR5V33X
         zevSZq9P4LcYsa8bshJNqHawzJUMVC2Xa8w8Y9mcO9Qb02fb6+itaf5FZweVUsiPUZ9H
         cN6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HcRiho973ngZafEIJab/gwLURlQ36AyAGmDbM50FuA4=;
        b=pO6HUNosoo7Oxp2IrtUJJ2Yw98qM/4Pfvxo3qXCipEHTVWLe4wVLtP49e1fOfXNhji
         h5PV7qP7vRADZhcFF+k3ldfk6vMRxcJdVjJLmJpY6SOUnQC2BN/sl0+h6BiSAUIiUr7V
         sgkobkzQ75NnajVpmky0EIAj3HeqytVTfw4gKbHpJZ+N5E0gIH5n7EJMuFjosAKp0k3n
         YByE5L739uzAVMmq5yiVDEBDGJxCdhx7mUOrG0F7LaqlkWKwYKjDUGxr5U7otZDpTTFF
         RnLhea4q/H19KWapiasNoVNtNo1stDPzLouL1+SJz6fAm3AXbb2E3ap6YPlv1BC/kfvk
         Dmqg==
X-Gm-Message-State: AOAM533TGcO/9jIlJxABTNXF1MHXnNxDnkgZW8Z9mWiygoippSg1fgQ6
        EIwMusobsGylQXcoXZZhuKPNsSjNmNaaUtcrjNIMpw==
X-Google-Smtp-Source: ABdhPJwfqYCPVN34MwaoI7yMreqN6YX1NTzLLJ1Lih0p33lU/WffPgm3zoAlunfAIcMx6kw3xO+WVJcQJl/JC9tM7fE=
X-Received: by 2002:a6b:5112:: with SMTP id f18mr12315872iob.196.1614621284488;
 Mon, 01 Mar 2021 09:54:44 -0800 (PST)
MIME-Version: 1.0
References: <161461457416034@kroah.com>
In-Reply-To: <161461457416034@kroah.com>
From:   "Cong Wang ." <cong.wang@bytedance.com>
Date:   Mon, 1 Mar 2021 09:54:33 -0800
Message-ID: <CAA68J_ZM-YhX+dWSw=JChPtQ-hQSJmSy_NZpD-pEWM+icVMuYg@mail.gmail.com>
Subject: Re: [Phishing Risk] [External] FAILED: patch "[PATCH] net_sched: fix
 RTNL deadlock again caused by request_module()" failed to apply to 5.4-stable tree
To:     gregkh@linuxfoundation.org
Cc:     jhs@mojatatu.com, jiri@resnulli.us, kuba@kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 1, 2021 at 8:02 AM <gregkh@linuxfoundation.org> wrote:
>
>
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

This patch is not suitable for -stable due to its large size.

Thanks.
