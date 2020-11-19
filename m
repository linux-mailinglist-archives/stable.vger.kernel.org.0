Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A7832B9B5A
	for <lists+stable@lfdr.de>; Thu, 19 Nov 2020 20:23:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727987AbgKSTPk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Nov 2020 14:15:40 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:4203 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727658AbgKSTPk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Nov 2020 14:15:40 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fb6c4600001>; Thu, 19 Nov 2020 11:15:44 -0800
Received: from [10.26.75.251] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 19 Nov
 2020 19:15:34 +0000
Subject: Re: [PATCH v2 6/6] thermal: tegra: Avoid setting edp_irq when not
 relevant
To:     Nicolas Chauvet <kwizart@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
CC:     <linux-tegra@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <stable@vger.kernel.org>
References: <20200927150956.34609-1-kwizart@gmail.com>
 <20200927150956.34609-7-kwizart@gmail.com>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <1ddb2245-fde0-644c-e89a-5f94015fc682@nvidia.com>
Date:   Thu, 19 Nov 2020 19:15:32 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200927150956.34609-7-kwizart@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605813344; bh=P8wOcgzHDHysvM8DY3r9OjnAvldoeo1HaRws/7olnzk=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=CH01VTU1yk62xWDzFhYBAQDNIm3Mvs9desaptzLSFYzvwpr+hZVXezGSoHtgC+CcM
         +MtAg8In8yk1AQX78dNipQFYuLZB+JN7PlAGJapCVQehuWPIkFmQBRHNT97M6U21/6
         MLHNkjQClI+FmimiHEwv+HidDUaXenXtBS5cELxnFH+vSY6wuzz1xvC9UOKu/ml+jU
         j2Wd4PyLPVUGjqu4oJpWwC2nI4lth6Bc7fQjqLIFUmLrnjXi1knd4WN3zjBM2xDLAk
         od2C+br5Semsr8k4EJR2NLr18UPqEPwxgjNkl1pkwndUTrZQ/kaYY5+EuKnlM6Lpfs
         7IyBcrkwFoWBw==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 27/09/2020 16:09, Nicolas Chauvet wrote:
> According to the binding, the edp_irq is not available on tegra124/132

It appears that the binding doc is not update to date or missing the
relevant information. Looking at the Tegra124 TRM I see that there is a
SOCTHERM EDP IRQ (51) and so maybe the correct fix is to add this.

Cheers
Jon

-- 
nvpublic
