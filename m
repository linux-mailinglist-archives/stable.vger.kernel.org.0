Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC9C61640BA
	for <lists+stable@lfdr.de>; Wed, 19 Feb 2020 10:46:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbgBSJqT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Feb 2020 04:46:19 -0500
Received: from mx2.suse.de ([195.135.220.15]:58334 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726495AbgBSJqT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Feb 2020 04:46:19 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 594C6AC22;
        Wed, 19 Feb 2020 09:46:17 +0000 (UTC)
Subject: Re: [PATCH] x86/ioperm: add new paravirt function update_io_bitmap
To:     Thomas Gleixner <tglx@linutronix.de>,
        xen-devel@lists.xenproject.org, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc:     Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        "VMware, Inc." <pv-drivers@vmware.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        stable@vger.kernel.org
References: <20200218154712.25490-1-jgross@suse.com>
 <87mu9fr4ky.fsf@nanos.tec.linutronix.de>
 <b0f33786-79b1-f8ee-24ae-ce9f9f4791af@suse.com>
 <8736b7q6ca.fsf@nanos.tec.linutronix.de>
From:   =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Message-ID: <4537af8d-e28f-1c27-53a9-e3208874037e@suse.com>
Date:   Wed, 19 Feb 2020 10:46:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <8736b7q6ca.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 19.02.20 10:22, Thomas Gleixner wrote:
> Jürgen Groß <jgross@suse.com> writes:
>> On 18.02.20 22:03, Thomas Gleixner wrote:
>>> BTW, why isn't stuff like this not catched during next or at least
>>> before the final release? Is nothing running CI on upstream with all
>>> that XEN muck active?
>>
>> This problem showed up by not being able to start the X server (probably
>> not the freshest one) in dom0 on a moderate aged AMD system.
>>
>> Our CI tests tend do be more text console based for dom0.
> 
> tools/testing/selftests/x86/io[perm|pl] should have caught that as well,
> right? If not, we need to fix the selftests.

Hmm, yes. Thanks for the pointer.

Will ask our testing specialist what is done in this regard and how it
can be enhanced.


Juergen
