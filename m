Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04DE620E936
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 01:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726894AbgF2XS2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 19:18:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:41894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726199AbgF2XS2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 19:18:28 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D20EE20776;
        Mon, 29 Jun 2020 23:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593472708;
        bh=Ap0GGyo3TT4bbUcnODAakDh+tdESRemEszuYecL7hu8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0bPCRdJ/elG7YYslCo5o8utl9pmlYGZbTiVI8rX41Rlp46edDosAP0eoH5jikoE+n
         G97w8RVRcigRB2FKRm1sLZ+0qJOrRascrZIgMjPdcqKk3lm7KeXVwPOl724ZPK8EmY
         iUglfuFMowRPQnyA4CxEqVJCYduZHu235Ui9TibI=
Date:   Mon, 29 Jun 2020 19:18:26 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 5.7 000/265] 5.7.7-rc1 review
Message-ID: <20200629231826.GT1931@sasha-vm>
References: <20200629151818.2493727-1-sashal@kernel.org>
 <42dadde8-04c0-863b-651a-1959a3d85494@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <42dadde8-04c0-863b-651a-1959a3d85494@linuxfoundation.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 29, 2020 at 02:37:53PM -0600, Shuah Khan wrote:
>Hi Sasha,
>
>On 6/29/20 9:13 AM, Sasha Levin wrote:
>>
>>This is the start of the stable review cycle for the 5.7.7 release.
>>There are 265 patches in this series, all will be posted as a response
>>to this one.  If anyone has any issues with these being applied, please
>>let me know.
>>
>>Responses should be made by Wed 01 Jul 2020 03:14:48 PM UTC.
>>Anything received after that time might be too late.
>>
>>The whole patch series can be found in one patch at:
>>	https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-5.7.y&id2=v5.7.6
>>
>
>Looks like patch naming convention has changed. My scripts look
>for the following convention Greg uses. Are you planning to use
>the above going forward? My scripts failed looking for the usual
>naming convention.
>
>The whole patch series can be found in one patch at:
>	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.6-rc1.gz
>or in the git tree and branch at:
>	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.7.y
>and the diffstat can be found below.

Sorry for that. I was hoping to avoid using the signed upload mechanism
Greg was using by simply pointing the links to automatically generated
patches on cgit (the git.kernel.org interface).

Would it be ok to change the pattern matching here? Something like this
should work for both Greg's format and my own (and whatever may come
next):

	grep -A1 "The whole patch series can be found in one patch at:" | tail -n1 | sed 's/\t//'

-- 
Thanks,
Sasha
