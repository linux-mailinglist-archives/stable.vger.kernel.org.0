Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 105CA2E1FA0
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 17:55:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbgLWQyy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 11:54:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726424AbgLWQyy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Dec 2020 11:54:54 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27FE2C061794
        for <stable@vger.kernel.org>; Wed, 23 Dec 2020 08:54:14 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id b5so78494pjk.2
        for <stable@vger.kernel.org>; Wed, 23 Dec 2020 08:54:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MUE9rWtM39yZX4aVcHM6fVkEJ6mlMioa2IjnbGk8PGA=;
        b=XPNNgC5E7i4we9Vm85N7ZzsLti/dhVg9PuLaqvZZTehEeqhEceH9ILE5GfvaXJe+jr
         dGc9Zk+dPt8SrZTS62PqJKjQVQw256Qh375NJLZHpjqp1klmulZjceH382xt3VSIaonk
         SGqMphmHPvKNzeANV7YLpMGjJoj/ZisyGikjPIdVQbfS2JydIr/A093O7JMBfoYSoQwj
         4aCqxCY0fzJsgngwZ6TmOg1yZdFQMT1D2BYouwD7Rd5ibVRKX2tuo0tHZhhqhVPqYwGM
         hMRkg601qzG1E4Yg3D3mKGA3jvQE0pfrVEjucbs5R4nPx+aYhMXzM5HgTVIa+Krvn4n6
         xTHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MUE9rWtM39yZX4aVcHM6fVkEJ6mlMioa2IjnbGk8PGA=;
        b=ajkzhiSAdzawX79in1M+GjSXkAzPM0Sm5J4N8pqCfAOPL14cNVuwT88DUmPv9q3QUz
         iRBg33NELS3m1zcNlolTSkavZfNWdz1Ou+G6t+VaVAFZzN8aAj1IkjSvtIoRIDXII35F
         cmY3f7UPRsyDOmfXbD0ydzZyWRsrCb8sA3c9B0+DwOGNtGM3B2RH4DdCxu4SDqJgEaYw
         p8489btdLRj+qKlDh5vj14dACGM5t3aI2BxbiFe8CHY3dGYTCPtr8QnpLxsnwQRvRcdi
         uBPm/G05HlqTAujYWx1MrqCkeEU2XFB/9Xy1mO3MeRJvpT5ClVtKtV+OB4IqxFRksfxM
         QK/Q==
X-Gm-Message-State: AOAM530TUAFZCfQ/WDw6VQ7LgiC0wuOobJYiYsEeo0KcQdU11SYDqhgA
        Jqoxtv8CppQdw7CMq1t6kFpoK6GW1GbkxXI=
X-Google-Smtp-Source: ABdhPJwEMjA4tyapfQJCf3up5B53d4gh7TrOvpdsafa03vwT9/+25qSmOzbwZJkCu/UlNncH3x03MQ==
X-Received: by 2002:a17:902:d210:b029:da:578f:741 with SMTP id t16-20020a170902d210b02900da578f0741mr26323469ply.82.1608742453682;
        Wed, 23 Dec 2020 08:54:13 -0800 (PST)
Received: from PWN (59-125-13-244.HINET-IP.hinet.net. [59.125.13.244])
        by smtp.gmail.com with ESMTPSA id b26sm25023801pgm.25.2020.12.23.08.54.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Dec 2020 08:54:13 -0800 (PST)
Date:   Wed, 23 Dec 2020 11:54:07 -0500
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     marcel@holtmann.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] Bluetooth: Fix slab-out-of-bounds read
 in" failed to apply to 4.14-stable tree
Message-ID: <20201223165407.GA15371@PWN>
References: <160873541518385@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160873541518385@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi all,

On Wed, Dec 23, 2020 at 03:56:55PM +0100, gregkh@linuxfoundation.org wrote:
> The patch below does not apply to the 4.14-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

I just generated a rebased patch that applies to 4.4, 4.9 and 4.14.  I
have sent it to syzbot for testing (once again, but against 4.14), and I
will send it here once syzbot is happy.

Cheers,
Peilin Ye

