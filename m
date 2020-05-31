Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 598641E94EC
	for <lists+stable@lfdr.de>; Sun, 31 May 2020 03:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729590AbgEaBua (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 May 2020 21:50:30 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:45536 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729026AbgEaBua (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 30 May 2020 21:50:30 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 49ZLq73rVxz1qrGG;
        Sun, 31 May 2020 03:50:27 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 49ZLq738d6z1r3kc;
        Sun, 31 May 2020 03:50:27 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id EySRwcSmJ6Xu; Sun, 31 May 2020 03:50:26 +0200 (CEST)
X-Auth-Info: i4STmeJ99b+tOLd8wRjIFzgy2TUSN36tnwgx7+SYrH4=
Received: from [IPv6:::1] (unknown [195.140.253.167])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Sun, 31 May 2020 03:50:26 +0200 (CEST)
To:     changbin.du@gmail.com, linux-stable <stable@vger.kernel.org>
Cc:     acme@kernel.org, jolsa@redhat.com, linux-kernel@vger.kernel.org,
        mingo@redhat.com, peterz@infradead.org
References: <20200128152938.31413-1-changbin.du@gmail.com>
Subject: Re: [PATCH] perf: Make perf able to build with latest libbfd
From:   Marek Vasut <marex@denx.de>
Message-ID: <70322330-524c-14ab-aace-e460677e25e3@denx.de>
Date:   Sun, 31 May 2020 03:50:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200128152938.31413-1-changbin.du@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

since commit
0ada120c883d ("perf: Make perf able to build with latest libbfd")
is in master, can it be backported to stable as well? I keep hitting
this with too new binutils on Linux 5.4.y and I have to keep
cherry-picking this commit to fix it.

Thanks
