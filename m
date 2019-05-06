Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D0DA14E19
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 16:58:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727151AbfEFO6l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:58:41 -0400
Received: from relay.sw.ru ([185.231.240.75]:34356 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728202AbfEFO6l (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:58:41 -0400
Received: from [172.16.25.12]
        by relay.sw.ru with esmtp (Exim 4.91)
        (envelope-from <aryabinin@virtuozzo.com>)
        id 1hNf4c-0004CF-P3; Mon, 06 May 2019 17:58:34 +0300
Subject: Re: [PATCH 4.9 10/62] kasan: rework Kconfig settings
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <20190506143051.102535767@linuxfoundation.org>
 <20190506143051.984481239@linuxfoundation.org>
From:   Andrey Ryabinin <aryabinin@virtuozzo.com>
Message-ID: <8bdd66ba-d6e8-ef65-47fd-cf18e18fcd3e@virtuozzo.com>
Date:   Mon, 6 May 2019 17:58:59 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190506143051.984481239@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 5/6/19 5:32 PM, Greg Kroah-Hartman wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> commit e7c52b84fb18f08ce49b6067ae6285aca79084a8 upstream.
> 

This is a fix/workaround for the previous patch c5caf21ab0cf "kasan: turn on -fsanitize-address-use-after-scope"
which shouldn't be in the -stable. So without c5caf21ab0cf we don't need this one.
