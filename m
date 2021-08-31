Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 317573FC2F7
	for <lists+stable@lfdr.de>; Tue, 31 Aug 2021 08:55:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236708AbhHaGss (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Aug 2021 02:48:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236181AbhHaGsq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Aug 2021 02:48:46 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9039C061575
        for <stable@vger.kernel.org>; Mon, 30 Aug 2021 23:47:51 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id lc21so36306206ejc.7
        for <stable@vger.kernel.org>; Mon, 30 Aug 2021 23:47:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=rkyRhn+hkwDPA/bzbVKQWAzdggr9qmfRf1HI0bSWCzA=;
        b=kEPxD8xR0Gk4as77WNNwFkIjlits/BTZwKp4/YRXwDtpLrRwS7uBmwXCwksOGBYAFa
         UweVbgA2ftDuphWoXR0WMiaZAxx07xGXwea1ICGILbUi4kgGXG+NydxBAeww1/OX5w3A
         hptZM4DG3rUld937Z/QZxqvusiDVHpi9bH1c0qQ+/GquY18mplT+OOEhaH0sOZMgDELm
         c8VbaMc2GwjetzL5Mf5lOSFz+DodL40lbPtcU/VEO/v0FFGfZ8o092R6TcKptB5TIATV
         NTsIhHdD7f1HuQzSX+2FDqQDJVh/tutMu+kolgftprMo1mw9yTaZWt+3zEMgQk0y7n/2
         O4xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=rkyRhn+hkwDPA/bzbVKQWAzdggr9qmfRf1HI0bSWCzA=;
        b=cJzQEaTq99Gu3a/BykfQDcZ0/fagPzq+9vQzFRvBH7NTdqNTAkpU8UjaEmNHip9Q7o
         mcHA2yydZpRfni1aYprAGg0+zMEBySxQLfY8xuZ7xclnFfIHPqqbMpUnOzjU5UeYxR8D
         MzWCP7antZmmSnIprizCxMjbIX/isUIfqiFDXqhZul6n0TZNq6M4mzSdH9HpRDg487ny
         +EE2nsuzQHA+TUVDS1mmebdKYPIHMuij1HaKdD26IMHbenQvX39eqdvUnn9onJ8p8KyZ
         /0QD3ZTYnVa/o00P8AeEpLXOkhHX4BLxYq7svzyGxkfq+Y6OWKCZqevwT5oZJ7CbI7aN
         V3uw==
X-Gm-Message-State: AOAM532flbKU9w361U59nza/zoKsYtz76TqWI/iUwo2npJtIglBcOloT
        YLlSiHPO3FAmEQZWWnObOQRKAtj1GeFcxVYgUxY=
X-Google-Smtp-Source: ABdhPJxsQc33o/ukPdf5QNXn1q/JpxIOP4uaEdpg2mFZp9P7MMSkAW1lxVBmf7bqkEgF15zLGawfmAFsrqnesZvZH6A=
X-Received: by 2002:a17:906:4784:: with SMTP id cw4mr28966905ejc.160.1630392470440;
 Mon, 30 Aug 2021 23:47:50 -0700 (PDT)
MIME-Version: 1.0
From:   Dongliang Mu <mudongliangabcd@gmail.com>
Date:   Tue, 31 Aug 2021 14:47:22 +0800
Message-ID: <CAD-N9QUhebBrJ1fZG-i09PSKjC9Vat3Ym5VHoOrXGAO_tKQdpQ@mail.gmail.com>
Subject: Linux kernel 4.19 and below misses the patch - "fbmem: add margin
 check to fb_check_caps()"
To:     Sasha Levin <sashal@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi stable maintainers,

It seems that Linux kernel 4.19 and below miss the patch - "fbmem: add
margin check to fb_check_caps()" [1]. Linux kernel 5.4 and up is
already merged this patch[2].

Are there any special issues about this patch? Why do maintainers miss
such a patch?

If I have any misunderstanding, please let me know.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=a49145acfb975d921464b84fe00279f99827d816

[2] https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-5.4.y&id=e80b7ebcfda70d5c10b050fddcd45c5e38af7176

--
My best regards to you.

     No System Is Safe!
     Dongliang Mu
