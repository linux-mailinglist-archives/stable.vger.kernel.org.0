Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B226E3263F1
	for <lists+stable@lfdr.de>; Fri, 26 Feb 2021 15:20:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbhBZOT2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Feb 2021 09:19:28 -0500
Received: from proxmox-new.maurer-it.com ([212.186.127.180]:24894 "EHLO
        proxmox-new.maurer-it.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbhBZOT2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Feb 2021 09:19:28 -0500
Received: from proxmox-new.maurer-it.com (localhost.localdomain [127.0.0.1])
        by proxmox-new.maurer-it.com (Proxmox) with ESMTP id C230541CA8;
        Fri, 26 Feb 2021 15:18:45 +0100 (CET)
Message-ID: <89a2c659-54d6-59ae-826e-c742efdb784b@proxmox.com>
Date:   Fri, 26 Feb 2021 15:18:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:86.0) Gecko/20100101
 Thunderbird/86.0
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jim Mattson <jmattson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
References: <20210104155705.740576914@linuxfoundation.org>
 <20210104155706.339275609@linuxfoundation.org>
 <85e3f488-4ec5-2ad3-26a6-097d532824e1@proxmox.com>
 <4fa31425-3c13-0a4f-167b-6566c6302334@redhat.com>
 <YDjwxF2RyKnsQqF/@kroah.com>
 <34df16e4-06a1-3343-2fd9-5004ec5f5fa1@redhat.com>
From:   Thomas Lamprecht <t.lamprecht@proxmox.com>
Subject: Re: [PATCH 5.4 12/47] KVM: x86: avoid incorrect writes to host
 MSR_IA32_SPEC_CTRL
In-Reply-To: <34df16e4-06a1-3343-2fd9-5004ec5f5fa1@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 26.02.21 15:15, Paolo Bonzini wrote:
> On 26/02/21 13:59, Greg Kroah-Hartman wrote:
>>>> So can you please add this patch to the stable trees that backported the
>>>> problematic upstream commit 6441fa6178f5456d1d4b512c08798888f99db185 ?
>>>>
>>>> If I should submit this in any other way just ask, was not sure about
>>>> what works best with a patch which cannot be cherry-picked cleanly.
>>>
>>> Ok, I'll submit it.
>>>
>>> Thanks for the testing.
>>
>> Does that mean I should not take the patch here in this email and that
>> you will submit it after some timeperiod, or that I should take this
>> patch as-is?
> 
> The patch that Thomas requested (commit 841c2be09fe) does not apply cleanly, so I'll take care of sending the backport.
> 

Note that the patch I added inline in my initial mail here was already
adapted to apply cleanly, at least on stable-5.4.y

May not have made that clear enough, so mentioning it here - ignore me this
message if that was read and thought of.

cheers,
Thomas


