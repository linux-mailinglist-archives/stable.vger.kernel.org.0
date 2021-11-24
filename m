Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D80645D083
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 23:53:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244790AbhKXW4N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 17:56:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231346AbhKXW4M (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Nov 2021 17:56:12 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A0B0C061574;
        Wed, 24 Nov 2021 14:53:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Date:Message-ID:From:Cc:To;
        bh=+Cel5t5mgEKdccPULfn4I2rYPBfGX3bHzdJOMnRwesQ=; b=IJW9NHZgjPfPHOj8Sm+sJbNmXo
        ZZd50MFikt34l2PoQZFxBWLLjhy3rC8T+0hkrKVLf0fPDOjHUNzRs7mZ0QV3cWqEf4zVAB3Uv9qFM
        jIJF+PF44NslkTiEiBKnYTio8m01//FBuSl4CEDN7CED1D+m9OhQbhr1lTVaOiy1mYCSb32+Cja20
        Pny3w0o62tPv0i3UujndWUWWEsY7nNoP/0sS9E/8BLAhKX5jE7OCx2+dFU1AegVZPtF5B8d05ico3
        +gLSX3fjn3eED+eVX/LxXNLZ7KEBhSa1QEHeR8kDkpUYMnbxbnzSnoYWkoWNVL8xC3GVwn8oW/FIE
        y9bdYAwG1VBgz0XNyVdJF30ck/pgWKqW7PQdRp1T83QY1st1i/jDo9N8NEdxIUdwJ/jGCLefgnule
        nh9KRfV+HNYgg4rXF0F0/WKc7gpmz/f/ttZQvVQrgd5TLHzKMAW+jjND2RxtxOwv0zKyweDHuDXbN
        c8qWv3IDvt3/M7Rc9P7iXAbj;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mq18M-008nwU-80; Wed, 24 Nov 2021 22:52:58 +0000
To:     Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Daniel Black <daniel@mariadb.org>,
        Salvatore Bonaccorso <carnil@debian.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        stable@vger.kernel.org
References: <c6d6bffe-1770-c51d-11c6-c5483bde1766@kernel.dk>
 <bd7289c8-0b01-4fcf-e584-273d372f8343@kernel.dk>
 <6d0ca779-3111-bc5e-88c0-22a98a6974b8@kernel.dk>
 <281147cc-7da4-8e45-2d6f-3f7c2a2ca229@kernel.dk>
 <c92f97e5-1a38-e23f-f371-c00261cacb6d@kernel.dk>
 <CABVffEN0LzLyrHifysGNJKpc_Szn7qPO4xy7aKvg7LTNc-Fpng@mail.gmail.com>
 <00d6e7ad-5430-4fca-7e26-0774c302be57@kernel.dk>
 <CABVffEM79CZ+4SW0+yP0+NioMX=sHhooBCEfbhqs6G6hex2YwQ@mail.gmail.com>
 <3aaac8b2-e2f6-6a84-1321-67409b2a3dce@kernel.dk>
 <98f8a00f-c634-4a1a-4eba-f97be5b2e801@kernel.dk> <YZ5lvtfqsZEllUJq@kroah.com>
 <c0a7ac89-2a8c-b1e3-00c2-96ee259582b4@kernel.dk>
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: uring regression - lost write request
Message-ID: <96d6241f-7bf0-cefe-947e-ee03d83fb828@samba.org>
Date:   Wed, 24 Nov 2021 23:52:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <c0a7ac89-2a8c-b1e3-00c2-96ee259582b4@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Jens,

>>> Looks good to me - Greg, would you mind queueing this up for
>>> 5.14-stable?
>>
>> 5.14 is end-of-life and not getting any more releases (the front page of
>> kernel.org should show that.)
> 
> Oh, well I guess that settles that...
> 
>> If this needs to go anywhere else, please let me know.
> 
> Should be fine, previous 5.10 isn't affected and 5.15 is fine too as it
> already has the patch.

Are 5.11 and 5.13 are affected, these are hwe kernels for ubuntu,
I may need to open a bug for them...

Thanks!
metze
