Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF4622BC5DB
	for <lists+stable@lfdr.de>; Sun, 22 Nov 2020 14:42:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727517AbgKVNme (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Nov 2020 08:42:34 -0500
Received: from gproxy1-pub.mail.unifiedlayer.com ([69.89.25.95]:47890 "EHLO
        gproxy1-pub.mail.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727513AbgKVNmd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Nov 2020 08:42:33 -0500
X-Greylist: delayed 740 seconds by postgrey-1.27 at vger.kernel.org; Sun, 22 Nov 2020 08:42:33 EST
Received: from cmgw12.unifiedlayer.com (unknown [10.9.0.12])
        by gproxy1.mail.unifiedlayer.com (Postfix) with ESMTP id EE723BA749AE4
        for <stable@vger.kernel.org>; Sun, 22 Nov 2020 06:30:12 -0700 (MST)
Received: from bh-25.webhostbox.net ([208.91.199.152])
        by cmsmtp with ESMTP
        id gpRUkX2tkeMJHgpRUkf72g; Sun, 22 Nov 2020 06:30:12 -0700
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.3 cv=T72iscCQ c=1 sm=1 tr=0
 a=QNED+QcLUkoL9qulTODnwA==:117 a=2cfIYNtKkjgZNaOwnGXpGw==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=kj9zAlcOel0A:10:nop_charset_1
 a=nNwsprhYR40A:10:nop_rcvd_month_year
 a=evQFzbml-YQA:10:endurance_base64_authed_username_1 a=zTUoEDChpA-VcAYVmHAA:9
 a=CjuIK1q_8ugA:10:nop_charset_2
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=roeck-us.net; s=default; h=In-Reply-To:Content-Type:MIME-Version:References
        :Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding
        :Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=+EZK8e1wUZmg2SWx+whbh9mPUb23f907Z1rah/T7D2M=; b=JRPScSBYXY/52NcuC2OU2xIX1M
        6xTpHWVkGi1+qOMRx9nQVjNyc3nS385OcPdnIWsEbP/qQuLBYcPcFiat7GW+JLlJoAGyjS59NMTVD
        DTgtQPQ3G2N2x7n8ApF4yydjbV6dbqCiyS1K0Vp9kauNMlUoSdS1tHKoEuYHEGfnPvAgdNN4S+3qG
        /K3w8qLlJMkZa/MLbHT+MKx9brhNKpLdZ+Aj/b9SyPflD8vS1A/ZWkgmVSWgcLIHrn0e6B9eM8xD3
        Q6GpD7eyO5f5HnAdb76j5a53AHn6uN994Lb1Qg+X529ONB9HKjatrH/AVTajV3cfnqF+AeWvkvkHF
        9y/g9Fww==;
Received: from 108-223-40-66.lightspeed.sntcca.sbcglobal.net ([108.223.40.66]:44492 helo=localhost)
        by bh-25.webhostbox.net with esmtpa (Exim 4.93)
        (envelope-from <linux@roeck-us.net>)
        id 1kgpRU-002iMt-1g; Sun, 22 Nov 2020 13:30:12 +0000
Date:   Sun, 22 Nov 2020 05:30:11 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     "Chatradhi, Naveen Krishna" <NaveenKrishna.Chatradhi@amd.com>
Cc:     Salvatore Bonaccorso <carnil@debian.org>,
        "linux-hwmon@vger.kernel.org" <linux-hwmon@vger.kernel.org>,
        "naveenkrishna.ch@gmail.com" <naveenkrishna.ch@gmail.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] hwmon: amd_energy: modify the visibility of the counters
Message-ID: <20201122133011.GA48943@roeck-us.net>
References: <20201112172159.8781-1-nchatrad@amd.com>
 <238e3cf7-582f-a265-5300-9b44948107b0@roeck-us.net>
 <20201113135834.GA354992@eldamar.lan>
 <DM6PR12MB438866557FEE8F42C0F6AF26E8FD0@DM6PR12MB4388.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR12MB438866557FEE8F42C0F6AF26E8FD0@DM6PR12MB4388.namprd12.prod.outlook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-BWhitelist: no
X-Source-IP: 108.223.40.66
X-Source-L: No
X-Exim-ID: 1kgpRU-002iMt-1g
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 108-223-40-66.lightspeed.sntcca.sbcglobal.net (localhost) [108.223.40.66]:44492
X-Source-Auth: guenter@roeck-us.net
X-Email-Count: 1
X-Source-Cap: cm9lY2s7YWN0aXZzdG07YmgtMjUud2ViaG9zdGJveC5uZXQ=
X-Local-Domain: yes
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Nov 22, 2020 at 06:56:24AM +0000, Chatradhi, Naveen Krishna wrote:
> [AMD Official Use Only - Approved for External Use]
> 
> Hi Guenter, Salvatore
> 
> > This is very unusual, and may mess up the "sensors" command.
> > What problem is this trying to solve ?
> Guenter, sorry for the delayed response.
> This fix is required to address the possible side channel attack reported in CVE-2020-12912.
> 
[ ... ]
> 
> >> ?
> Yes, Salvatore, thanks for bringing the links. 
> 
A much better fix would have been to cache RAPL data for a short period
of time. To avoid any possibility of attacks, maybe add some random
interval. Something like this:

In accumulate_delta():
	accums->next_update = jiffies + HZ / 2 + get_random_int % HZ;

In amd_energy_read():
	accum = &data->accums[channel];
	if (time_after(accum->next_update))
		accumulate_delta(data, channel, cpu, reg);
	*val = div64_ul(accum->energy_ctr * 1000000UL, BIT(data->energy_units));

and drop amd_add_delta().

Guenter
