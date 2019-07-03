Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB2A05E3B1
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 14:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbfGCMTa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jul 2019 08:19:30 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54687 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbfGCMT3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Jul 2019 08:19:29 -0400
Received: from mail-wr1-f72.google.com ([209.85.221.72])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <guilherme.piccoli@canonical.com>)
        id 1hieER-0004xt-Js
        for stable@vger.kernel.org; Wed, 03 Jul 2019 12:19:27 +0000
Received: by mail-wr1-f72.google.com with SMTP id s18so1002940wru.16
        for <stable@vger.kernel.org>; Wed, 03 Jul 2019 05:19:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hl4IN+UFShyWybz5Y9nFx/v6kLwn65u0JGDKlBXalYE=;
        b=Rxe+RdGYAUppLPMEXdrk8C647DoyrhuolulbOHyrS4D3FK+Nzk+7MN0j/jtW2qqMdC
         R9CR9p0TwDvOZZJGm09VNIEF0sGIj+q83sHsTTI0sFnGT3cRuybufeHLJ1iecYS7I5bw
         Bp+EGA9eTPjIklhkAYCsRnfhyyvzJseksmo8t18QDKWTPK5600ldBXtN8wfHRcqGkKG1
         T4h6rtGDqnWHExt6GdpEXrbwlOZeZROq0j6xst3e020c4wE2TyBkNhhPBZnJX4T41eCu
         6NllWcdbcV6VnEntB5dt7lo50pST5/Sf0lQZfMoHqvucuDu/H0I1qL2H6jqUWknSq/Zv
         CiiQ==
X-Gm-Message-State: APjAAAUZ85ZOtiVPDqh7yIqqY6YzCTUI053O5GRE1x4GVd+rCAq4F9Zo
        sl8UfUNFYq80v2BhUBsEFV8XqtM1RynBKI6ZPJ5QR4ch93pZRjfD8TbvkiRYsr68qMT61BRphNV
        /ECnjTmOD1B9ObsG6VW6y4I8o8qfuZGV2AUtiDZkTyXvB7ifsRg==
X-Received: by 2002:a1c:7304:: with SMTP id d4mr7806062wmb.39.1562156367411;
        Wed, 03 Jul 2019 05:19:27 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzWDxudz+dZ2eL2tgM1xv05DBOxBXD5d9mfD6trqmEZtBgjgFSRf5Jats2GQunAnlnOsWSWp007ri9L831lJAw=
X-Received: by 2002:a1c:7304:: with SMTP id d4mr7806046wmb.39.1562156367242;
 Wed, 03 Jul 2019 05:19:27 -0700 (PDT)
MIME-Version: 1.0
References: <20190628221759.18274-1-gpiccoli@canonical.com> <20190703121700.GE7784@kroah.com>
In-Reply-To: <20190703121700.GE7784@kroah.com>
From:   Guilherme Piccoli <gpiccoli@canonical.com>
Date:   Wed, 3 Jul 2019 09:18:51 -0300
Message-ID: <CAHD1Q_z+V7NgL1cT3hWioWwWfpViNHDLbhpK=USbBnE=MY7X+A@mail.gmail.com>
Subject: Re: [4.19.y PATCH 1/2] block: Fix a NULL pointer dereference in generic_make_request()
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        linux-block@vger.kernel.org,
        linux-raid <linux-raid@vger.kernel.org>,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Song Liu <songliubraving@fb.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Ming Lei <ming.lei@redhat.com>,
        Eric Ren <renzhengeek@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 3, 2019 at 9:17 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> [...]
> Both patches now queued up, thanks.

Thanks a lot Song and Greg!
Cheers,


Guilherme
