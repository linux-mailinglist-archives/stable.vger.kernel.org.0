Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB246320533
	for <lists+stable@lfdr.de>; Sat, 20 Feb 2021 13:13:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbhBTMNF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Feb 2021 07:13:05 -0500
Received: from mail.xenproject.org ([104.130.215.37]:54760 "EHLO
        mail.xenproject.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbhBTMNF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Feb 2021 07:13:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=xen.org;
        s=20200302mail; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject;
        bh=bQI3Ccup6yTIKmHa56nvcajDRXzkAB6HThNzesI2iXU=; b=lB2ygTAnJokH5Xh2dCOi/z2iZo
        gJEn36BjiNPpV/WPhRsJ1hbLzvpOxpIgdFONvx94OiQG5YIh8DqilRSb/6q3f2OzzHcyOycYs8AXm
        W6OQIhbdXauznCSyDbuErPjDa6qK7iSxYdS3yTFhyu9OSKi3zQFE85Qc9FEG5lvUmFWw=;
Received: from xenbits.xenproject.org ([104.239.192.120])
        by mail.xenproject.org with esmtp (Exim 4.92)
        (envelope-from <julien@xen.org>)
        id 1lDR7Q-0002Ad-Ue; Sat, 20 Feb 2021 12:12:16 +0000
Received: from [54.239.6.185] (helo=a483e7b01a66.ant.amazon.com)
        by xenbits.xenproject.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <julien@xen.org>)
        id 1lDR7Q-0008An-I2; Sat, 20 Feb 2021 12:12:16 +0000
Subject: Re: [PATCH v3 3/8] xen/events: avoid handling the same event on two
 cpus at the same time
To:     Juergen Gross <jgross@suse.com>, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        stable@vger.kernel.org
References: <20210219154030.10892-1-jgross@suse.com>
 <20210219154030.10892-4-jgross@suse.com>
From:   Julien Grall <julien@xen.org>
Message-ID: <495a12e4-d54b-0841-07b2-5b0a0cea5d10@xen.org>
Date:   Sat, 20 Feb 2021 12:12:14 +0000
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210219154030.10892-4-jgross@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Juergen,

On 19/02/2021 15:40, Juergen Gross wrote:
> When changing the cpu affinity of an event it can happen today that
> (with some unlucky timing) the same event will be handled on the old
> and the new cpu at the same time.
> 
> Avoid that by adding an "event active" flag to the per-event data and
> call the handler only if this flag isn't set.
> 
> Cc: stable@vger.kernel.org
> Reported-by: Julien Grall <julien@xen.org>
> Signed-off-by: Juergen Gross <jgross@suse.com>

Reviewed-by: Julien Grall <jgrall@amazon.com>

Cheers,

-- 
Julien Grall
