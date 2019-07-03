Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C9D15DB05
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 03:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbfGCBjn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 21:39:43 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:37039 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbfGCBjn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jul 2019 21:39:43 -0400
Received: by mail-ed1-f68.google.com with SMTP id w13so414907eds.4;
        Tue, 02 Jul 2019 18:39:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xv6Z2w7AXk92Vbzt4aqL4v0EY5bcvUni5jxfgnSS2X4=;
        b=vBiIeW9bFNunEW4y2IugAzdpjTePbxfP9J0ybTq2bnsVP4Fl7QW61pngKWqUIUrJt/
         opaKadhTBaDLpSqKWyixYloIWQhFCJra8GnQDDW8enxAC2D7aSo+Vq+kHtMkqBlUJgza
         in7TNAfvTg5HFSU4kHEJzR4/GmcTAKClwzCMBJ7GkmUsmHxlH0LXaUrjMRxFEFt2agmV
         goKHC8epixWBWZTWq6GPfRm04jTfVeUnTBJr68JsqS3B5VGX/vciNpVVVxTyEH095Hl4
         1Dtm8Uz1BSDW1fhfnC1aHFjWq1rp9oyo0mRXe25G+4cKWGSZUqYrUQ7Y91B0WzzMG/xY
         d+JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xv6Z2w7AXk92Vbzt4aqL4v0EY5bcvUni5jxfgnSS2X4=;
        b=YXdVk6OvtUka/HIgGwgnAzN3ETmU0eYnknInJB/+3sdZATmhl1iu57eaxzmEDSNW9R
         TRRr5FltRu8ZuMvwyjHEw54+9hDQmrx479mGfLfxsB8Mtv+kNALaiOx2HJ4577/IMEGV
         CMu74wSKMcDCobiW7qurXhhbdVbOHCmSsq4mjlCB+gvGs6Gwxoaj1MwVctJgJgdYmO6w
         3uI+KM8SvCh41prn0r1RDb0R7MGI0lex9MQ6XumUvuakFLp1ReeZS3EVcRcRNCbptXZY
         UA299Gl5L/X+ADixszpU+1w3yvyAQFXVrcftfL0JMP+0RLrHm4Fx91MsGyB2VC8I9277
         YELw==
X-Gm-Message-State: APjAAAVqOKlIHy5yZhSuqdkelGPE80lRIumJkmsAZayqgPwwOwjqAC3f
        zvJuhTZFTmU3ApPX72G/BA4=
X-Google-Smtp-Source: APXvYqwrLtCnEUAfps9E5gDVqiIlzIoWVwm2iRYk7xzsJoj47a3BVX1i6951g0EonpzWMlMC/XccCA==
X-Received: by 2002:a50:f4dd:: with SMTP id v29mr39081283edm.246.1562117981276;
        Tue, 02 Jul 2019 18:39:41 -0700 (PDT)
Received: from [10.68.217.182] ([217.70.211.18])
        by smtp.gmail.com with ESMTPSA id l50sm212064edb.77.2019.07.02.18.39.39
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jul 2019 18:39:40 -0700 (PDT)
Subject: Re: [PATCH] filesystem-dax: Disable PMD support
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     Matthew Wilcox <willy@infradead.org>,
        Seema Pandit <seema.pandit@intel.com>,
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
 <fa9b9165-7910-1fbd-fb5b-78023936d2f2@gmail.com>
 <CAPcyv4ihQ9djQvgnqZoTLRH3CwFhpWK_uUrmWSLH_3-Fi1g1qw@mail.gmail.com>
From:   Boaz Harrosh <openosd@gmail.com>
Message-ID: <1eac7cfb-a23c-097e-8dba-d83e6921f152@gmail.com>
Date:   Wed, 3 Jul 2019 04:39:38 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <CAPcyv4ihQ9djQvgnqZoTLRH3CwFhpWK_uUrmWSLH_3-Fi1g1qw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 03/07/2019 03:42, Dan Williams wrote:
> On Tue, Jul 2, 2019 at 5:23 PM Boaz Harrosh <openosd@gmail.com> wrote:
<>
> 
> Yes, but the trick is how to manage cases where someone waiting on one
> type needs to be woken up by an event on the other. 

Exactly I'm totally with you on this.

> So all I'm saying it lets live with more hash collisions until we can figure out a race
> free way to better scale waitqueue usage.
> 

Yes and lets actually do real measurements to see if this really hurts needlessly.
Maybe not so much

Thanks
Boaz

<>
