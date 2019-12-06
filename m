Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18EFF114F95
	for <lists+stable@lfdr.de>; Fri,  6 Dec 2019 12:04:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbfLFLEm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Dec 2019 06:04:42 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:10008 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726302AbfLFLEm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Dec 2019 06:04:42 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dea35c50000>; Fri, 06 Dec 2019 03:04:37 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 06 Dec 2019 03:04:42 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 06 Dec 2019 03:04:42 -0800
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 6 Dec
 2019 11:04:41 +0000
Received: from [10.21.133.51] (172.20.13.39) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 6 Dec 2019
 11:04:40 +0000
Subject: Re: stable request: 5.4.y: arm64: tegra: Fix 'active-low' warning for
 Jetson
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <stable@vger.kernel.org>
CC:     linux-tegra <linux-tegra@vger.kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>
References: <16724779-0514-ca92-58b2-95f4e244c6f7@nvidia.com>
Message-ID: <28364ffa-586e-bdcd-acf3-119742c92185@nvidia.com>
Date:   Fri, 6 Dec 2019 11:04:38 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <16724779-0514-ca92-58b2-95f4e244c6f7@nvidia.com>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1575630277; bh=gUKA2W4OC4+Oc3SZfMbDcZly8V4T7aFkvrhLJYrFcvM=;
        h=X-PGP-Universal:Subject:From:To:CC:References:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=mLi5Up3lMiagcBTJsw9/NOeW39jjTqMZ4/FFxACxW7uH2b8XEyq6XtZEtqtn72Uyf
         SAeQbg6Pykm0B2ePnnGk7nQk/ZNWVzzaGuJb6TsSgwgOg04r308fP7OHHR/316Tl0D
         xxMwQt6bREnMy0Xahys9rDdBJgT45OGIsFnmE/mfe8ZxyezMSQeVSXhCMdlY8EmUKF
         r12md0t/XALRcGkQn32FjKN6dvtqUBddyAcPk6cvdWvvAkLMQ0MqpibIXbptHlsxv4
         fTzARPRpDEvr/21qGDN/fCL8aQq5t/XGqbE+CAtPxPpWNWW0DUQASNpn26SCIqw/YH
         UJ0w7r7dbspYQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 06/12/2019 10:55, Jon Hunter wrote:
> External email: Use caution opening links or attachments

Sorry ignore the above nonsense. Looks like a nice new 'feature' that
was sprung on us. I should be able to get this removed for future.

Jon

-- 
nvpublic
