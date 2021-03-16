Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D21C33CE05
	for <lists+stable@lfdr.de>; Tue, 16 Mar 2021 07:38:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231866AbhCPGiB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 02:38:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:54986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231483AbhCPGhl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 02:37:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96B4E6521F;
        Tue, 16 Mar 2021 06:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615876660;
        bh=cRWsW7dLzxoXxFXLdN5guDFC94P+2LQJky93emcQJbc=;
        h=From:Date:Subject:To:From;
        b=r1GVG7MwFYxdJUdcvlRwHKVI3YKBuwLyVpI7pCYyMhkrW5KLlIXpONjPr6+uNvz6I
         SyBykSeBwSXdLIC25rKWQBVPceojTiiAmAKx3Vf0ZbqJFrsRquV/hXpYtXBDhI6jlB
         XHUYaDFi2zpIqpUp4QyKE31L6VaPg3S844YvyC4nbtb5uWGdUchTRS903GazzFhXQl
         jqmMYwSCoSXrNcJp/p3IjaHX7d/h+sFFl9Bbdyz6Mjd1Q3HJI99PJk3/Hcrb3AFCwG
         YBDVUt/t7JoWyqlRNN0iQ9NH5CqgWowNSrcd0jBGfyAKCWHN4lCHtn0IuSlq80m/M1
         PvfxMIySSz0Uw==
Received: by mail-oi1-f175.google.com with SMTP id t83so27087335oih.12;
        Mon, 15 Mar 2021 23:37:40 -0700 (PDT)
X-Gm-Message-State: AOAM533bpxFXSANb0v5ieKLCkMcHre/AjzQcb8osU3KIY2CS2jAWctai
        hWMWGDg9RQ0LSug7wfNvIXlAqQ1WtGIA65sJLOY=
X-Google-Smtp-Source: ABdhPJy67I0VitzUc4Nzm86yDyBlCDfEpoCp4ZtQIakg67LB/1lQ510zVI0EB1QvwjdEyAVWc8ke0ISKnMO76gFnCok=
X-Received: by 2002:aca:538c:: with SMTP id h134mr2244110oib.174.1615876660008;
 Mon, 15 Mar 2021 23:37:40 -0700 (PDT)
MIME-Version: 1.0
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 16 Mar 2021 07:37:29 +0100
X-Gmail-Original-Message-ID: <CAMj1kXHZhs9Zv_iMzRxKHHFZvAtKZn+Wyzg+Q=z1DUeTEB9m2Q@mail.gmail.com>
Message-ID: <CAMj1kXHZhs9Zv_iMzRxKHHFZvAtKZn+Wyzg+Q=z1DUeTEB9m2Q@mail.gmail.com>
Subject: stable request
To:     "# 3.4.x" <stable@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Please consider backporting commit

86ad60a65f29dd862a11c22bb4b5be28d6c5cef1
crypto: x86/aes-ni-xts - use direct calls to and 4-way stride

to stable. It addresses a rather substantial retpoline-related
performance regression in the AES-NI XTS code, which is a widely used
disk encryption algorithm on x86.

-- 
Ard.
