Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8335D8C0
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 02:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727172AbfGCA23 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 20:28:29 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:33962 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727164AbfGCA23 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jul 2019 20:28:29 -0400
Received: by mail-ed1-f65.google.com with SMTP id s49so322577edb.1;
        Tue, 02 Jul 2019 17:28:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=O3TFYB/c8JGnIRSgqNPJw6u3GSkSqR28UU4ekieR1ww=;
        b=c0Orqe6NQBE+sHLXT5J5nmlLtMemzO5waTwx4hEj7Bl04/hl6C0P+6hPRYDEAfph90
         kg1ZVytJWoslu+wvzvpUmTJPGiWopB+CqjCPc1Ge/93q2IP0ruxhLtlIhl9ed5+hAqt5
         /04yd0PyFdt0vekPpPo4dFYgQoX6r20BGdXRZhU33xxOAymQ9VLEdjBkSUPX4Ohh4xaK
         oeKBpm1hXGBKA61bwDXLWcFXYxJKHcfDwnjVubiVNIz/V5hs0Bw4n8t7dH6rTZ7TISUi
         8mAGclvqyCqY9XkLjYY0ydocBF0Zn5lUOoodMkb+gzJ84nYE5DlVPwzL6wE4hw5zTVn7
         NnOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=O3TFYB/c8JGnIRSgqNPJw6u3GSkSqR28UU4ekieR1ww=;
        b=m1quNqkNMIdkPgcBHittKTv5Ykk16LxXkEtft1qw4SIdIpd1As8bUm5H/MPIsWbuVW
         5iDyNyVkBqyowa12CsL+g/RkAdC3u2qVklMFerSERexeZC9NS/e8CV7D1EeTH4HSGTso
         ZKmoCs/3obLYMdZJqNCR23Ru1yaMw72fIk5XlndXEqJDYlO9FWf1QXrKPqnqZu9BLX1w
         5T37MktAZtp+DaqkCXcPRGeaI0NzLub7voc+ozvgGCmYv506UClX6Ixfx1UQR/Yd1QM+
         MX1k9VqAJUkgoVvanth59MXeGxDb4hU41cM6hq2owxaGFcoG8NVMttnfDvyiVuexfbuW
         mQaA==
X-Gm-Message-State: APjAAAWzSwxBgVJkVU2aawStGXYi+/H0LQgZfpPVJECaLY9p4vjFNxeu
        /vyfyUWFWlR1YBiT5bzh6xs=
X-Google-Smtp-Source: APXvYqw0ZksS0YC+pGL/ouOk9KhOw5LGAqS0CHttjy+Br4pM+v+dICQr6KzW3wmEDGg0H++t5zQLow==
X-Received: by 2002:aa7:c692:: with SMTP id n18mr38211777edq.220.1562113372104;
        Tue, 02 Jul 2019 17:22:52 -0700 (PDT)
Received: from [10.68.217.182] ([217.70.211.18])
        by smtp.gmail.com with ESMTPSA id b19sm113853eje.80.2019.07.02.17.22.50
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jul 2019 17:22:51 -0700 (PDT)
Subject: Re: [PATCH] filesystem-dax: Disable PMD support
To:     Dan Williams <dan.j.williams@intel.com>,
        Matthew Wilcox <willy@infradead.org>
Cc:     Seema Pandit <seema.pandit@intel.com>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Robert Barror <robert.barror@intel.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Jan Kara <jack@suse.cz>
References: <CAPcyv4jjqooboxivY=AsfEPhCvxdwU66GpwE9vM+cqrZWvtX3g@mail.gmail.com>
 <CAPcyv4h6HgNE38RF5TxO3C268ZvrxgcPNrPWOt94MnO5gP_pjw@mail.gmail.com>
 <CAPcyv4gwd1_VHk_MfHeNSxyH+N1=aatj9WkKXqYNPkSXe4bFDg@mail.gmail.com>
 <20190627195948.GB4286@bombadil.infradead.org>
 <CAPcyv4iB3f1hDdCsw=Cy234dP-RXpxGyXDoTwEU8nt5qUDEVQg@mail.gmail.com>
 <20190629160336.GB1180@bombadil.infradead.org>
 <CAPcyv4ge3Ht1k_v=tSoVA6hCzKg1N3imhs_rTL3oTB+5_KC8_Q@mail.gmail.com>
 <CAA9_cmcb-Prn6CnOx-mJfb9CRdf0uG9u4M1Vq1B1rKVemCD-Vw@mail.gmail.com>
 <20190630152324.GA15900@bombadil.infradead.org>
 <CAPcyv4j2NBPBEUU3UW1Q5OyOEuo9R5e90HpkowpeEkMsAKiUyQ@mail.gmail.com>
 <20190702033410.GB1729@bombadil.infradead.org>
 <CAPcyv4iEkN1o5HD6Gb9m5ohdAVQhmtiTDcFE+PMQczYx635Vwg@mail.gmail.com>
From:   Boaz Harrosh <openosd@gmail.com>
Message-ID: <fa9b9165-7910-1fbd-fb5b-78023936d2f2@gmail.com>
Date:   Wed, 3 Jul 2019 03:22:49 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <CAPcyv4iEkN1o5HD6Gb9m5ohdAVQhmtiTDcFE+PMQczYx635Vwg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 02/07/2019 18:37, Dan Williams wrote:
<>
> 
> I'd be inclined to do the brute force fix of not trying to get fancy
> with separate PTE/PMD waitqueues and then follow on with a more clever
> performance enhancement later. Thoughts about that?
> 

Sir Dan

I do not understand how separate waitqueues are any performance enhancement?
The all point of the waitqueues is that there is enough of them and the hash
function does a good radomization spread to effectively grab a single locker
per waitqueue unless the system is very contended and waitqueues are shared.
Which is good because it means you effectively need a back pressure to the app.
(Because pmem IO is mostly CPU bound with no long term sleeps I do not think
 you will ever get to that situation)

So the way I understand it having twice as many waitqueues serving two types
will be better performance over all then, segregating the types each with half
the number of queues.

(Regardless of the above problem of where the segregation is not race clean)

Thanks
Boaz
