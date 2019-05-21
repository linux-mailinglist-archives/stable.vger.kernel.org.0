Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5CF24EA6
	for <lists+stable@lfdr.de>; Tue, 21 May 2019 14:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726995AbfEUMIS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 May 2019 08:08:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41060 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726750AbfEUMIS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 May 2019 08:08:18 -0400
Received: from mail-wr1-f72.google.com ([209.85.221.72])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <guilherme.piccoli@canonical.com>)
        id 1hT3Z2-0006ui-Jf
        for stable@vger.kernel.org; Tue, 21 May 2019 12:08:16 +0000
Received: by mail-wr1-f72.google.com with SMTP id d18so2507435wre.22
        for <stable@vger.kernel.org>; Tue, 21 May 2019 05:08:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eXhU7/Nn4406vWILE1V7HnwbpPCsuskWXUNv5gI4pr8=;
        b=RFcJtPGW1R6rh4UO5mNw0Oe27g78OwSf/vTSiAQhAeZwyRo5Hsh/ggpr5nM1P5zxNL
         Z9wox2L4/TZ3fA/HTmwlJsyQN6A9doHkA9+aJAGCpWAhWd6TkmggKk9ZZH8t0gbzRKJF
         cKCMq1GuR/W4LR26fGqzwWmTNLa24BbgSADJOKtxiAeWIANTIrGouJ0d4ySWKmQZ2/1C
         yBUIt5yAVNnwA7EwY501/wYu9wzFcxreGNttZX0K+O7Zo8JxiWHHqfZPqZ8Yl0x0DYFU
         Sx/tDedSGeQ4eW/GUMiFhm2I4LSZpBC956Q6J84IA8fc0Yo5USJ49eEprrNhrhIv9EdH
         +oSg==
X-Gm-Message-State: APjAAAXc9YIf+CilxLKs/PCg2U9GXi7DjdesvSYybpafxa5GhxEY0kpl
        ZXL2itJ0WYTcmlGX/pjkiaIiX+V0/sfYQ/WFWVQ4dmZUTNhdnUa08vrTAHOEPi5XbALc5yPeOj/
        MElxiDZINyM/8+TShkaJmH5SkldLWj5Pj7Y3lTYIevNJH6rG7NQ==
X-Received: by 2002:adf:8306:: with SMTP id 6mr37224348wrd.155.1558440496433;
        Tue, 21 May 2019 05:08:16 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxFs6jLle8rolj8Uvchcc0hIOU9iziAkdiGdWrTuNrb0vVhuvAlwYbeJAsL050r5pHjQwVAgcnfki4xEyGbzcU=
X-Received: by 2002:adf:8306:: with SMTP id 6mr37224310wrd.155.1558440495856;
 Tue, 21 May 2019 05:08:15 -0700 (PDT)
MIME-Version: 1.0
References: <20190520220911.25192-1-gpiccoli@canonical.com> <CAPhsuW6KayaNR-0eFHpvPG-LVuPFL_1OFjvZpOcnapVFe2vC9Q@mail.gmail.com>
In-Reply-To: <CAPhsuW6KayaNR-0eFHpvPG-LVuPFL_1OFjvZpOcnapVFe2vC9Q@mail.gmail.com>
From:   Guilherme Piccoli <gpiccoli@canonical.com>
Date:   Tue, 21 May 2019 09:07:38 -0300
Message-ID: <CAHD1Q_wkziJYx4z0JcBavmQRzTh3a4g5xZG8bhVX+TYTkhaTrg@mail.gmail.com>
Subject: Re: [PATCH V2 1/2] block: Fix a NULL pointer dereference in generic_make_request()
To:     Song Liu <liu.song.a23@gmail.com>
Cc:     linux-block@vger.kernel.org,
        linux-raid <linux-raid@vger.kernel.org>, dm-devel@redhat.com,
        axboe@kernel.dk, Gavin Guo <gavin.guo@canonical.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        "Guilherme G. Piccoli" <kernel@gpiccoli.net>,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Ming Lei <ming.lei@redhat.com>,
        Eric Ren <renzhengeek@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 21, 2019 at 2:59 AM Song Liu <liu.song.a23@gmail.com> wrote:
> Applied both patches! Thanks for the fix!
>

Thanks Song!
