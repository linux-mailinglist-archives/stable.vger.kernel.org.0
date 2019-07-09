Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5520B62CEB
	for <lists+stable@lfdr.de>; Tue,  9 Jul 2019 02:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726391AbfGIAKH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 20:10:07 -0400
Received: from outgoing-stata.csail.mit.edu ([128.30.2.210]:51903 "EHLO
        outgoing-stata.csail.mit.edu" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726258AbfGIAKH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Jul 2019 20:10:07 -0400
Received: from [4.30.142.84] (helo=srivatsab-a01.vmware.com)
        by outgoing-stata.csail.mit.edu with esmtpsa (TLS1.2:RSA_AES_128_CBC_SHA1:128)
        (Exim 4.82)
        (envelope-from <srivatsa@csail.mit.edu>)
        id 1hkdhi-00061d-3d; Mon, 08 Jul 2019 20:09:54 -0400
Subject: Re: [4.4.y PATCH 0/4] Backported fixes for 4.4 stable tree
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     stable@vger.kernel.org, gregkh@linuxfoundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>, Wei Wu <ww9210@gmail.com>,
        Gen Zhang <blackgod016574@gmail.com>, akaher@vmware.com,
        srinidhir@vmware.com, bvikas@vmware.com, amakhalov@vmware.com,
        srivatsab@vmware.com
References: <156174751125.35226.7600381640894671668.stgit@srivatsa-ubuntu>
 <20190701153252.GA32227@redhat.com>
From:   "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>
Message-ID: <b8c370d6-469d-01f7-eff7-ce4b68ecbe1e@csail.mit.edu>
Date:   Mon, 8 Jul 2019 17:09:50 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190701153252.GA32227@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Vivek,

On 7/1/19 8:32 AM, Vivek Goyal wrote:
> On Fri, Jun 28, 2019 at 11:45:40AM -0700, Srivatsa S. Bhat wrote:
>> Hi,
>>
>> This patchset includes a few backported fixes for the 4.4 stable tree.
>> I would appreciate if you could kindly consider including them in the
>> next release.
>>
>> Thank you!
>>
>> Regards,
>> Srivatsa
>>
>> ---
>>
>> Gen Zhang (2):
>>       ip_sockglue: Fix missing-check bug in ip_ra_control()
>>       ipv6_sockglue: Fix a missing-check bug in ip6_ra_control()
>>
>> Vivek Goyal (1):
>>       ovl: modify ovl_permission() to do checks on two inodes
> 
> Hi Srivatsa,
> 
> Curious, why are you backporting above patch. These changes were done in
> a series primarily to support SELinux with overlay. Are you fixing a
> particular issue with this single patch?
> 
Sorry for the late reply. I backported this patch because it fixes
CVE-2018-16597.

Regards,
Srivatsa
