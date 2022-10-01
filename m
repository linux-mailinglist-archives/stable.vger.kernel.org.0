Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0410A5F1BB7
	for <lists+stable@lfdr.de>; Sat,  1 Oct 2022 12:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbiJAKHp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Oct 2022 06:07:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiJAKHn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 1 Oct 2022 06:07:43 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 809DD1116EE
        for <stable@vger.kernel.org>; Sat,  1 Oct 2022 03:07:42 -0700 (PDT)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1oeZPI-0005yb-6G; Sat, 01 Oct 2022 12:07:40 +0200
Message-ID: <e3e2915d-1411-a758-3991-48d6c2688a1e@leemhuis.info>
Date:   Sat, 1 Oct 2022 12:07:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Content-Language: en-US, de-DE
To:     =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Slade Watkins <srw@sladewatkins.net>,
        Jerry Ling <jiling@cern.ch>
References: <55905860-adf9-312c-69cc-491ac8ce1a8b@cern.ch>
 <YzZynE2FAMNQKm2E@kroah.com> <YzaFq7fzw5TbrJyv@kroah.com>
 <03147889-B21C-449B-B110-7E504C8B0EF4@sladewatkins.net>
 <aa8b9724-50c6-ae2e-062d-3791144ac97e@cern.ch>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
Subject: Re: Regression on 5.19.12, display flickering on Framework laptop
In-Reply-To: <aa8b9724-50c6-ae2e-062d-3791144ac97e@cern.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1664618862;7fe9cea0;
X-HE-SMSGID: 1oeZPI-0005yb-6G
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_PDS_OTHER_BAD_TLD autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 30.09.22 14:26, Jerry Ling wrote:
> 
> looks like someone has done it:
> https://bbs.archlinux.org/viewtopic.php?pid=2059823#p2059823
> 
> and the bisect points to:
> 
> |# first bad commit: [fc6aff984b1c63d6b9e54f5eff9cc5ac5840bc8c]
> drm/i915/bios: Split VBT data into per-panel vs. global parts Best, Jerry |

FWIW, that's 3cf050762534 in mainline. Adding Ville, its author to the
list of recipients.

Did anyone check if a revert on top of 5.19.12 works easily and solves
the problem?

And does anybody known if mainline affected, too?

Ciao, Thorsten


> On 9/30/22 07:11, Slade Watkins wrote:
>> Hey Greg,
>>
>>> On Sep 30, 2022, at 1:59 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
>>>
>>> On Fri, Sep 30, 2022 at 06:37:48AM +0200, Greg KH wrote:
>>>> On Thu, Sep 29, 2022 at 10:26:25PM -0400, Jerry Ling wrote:
>>>>> Hi,
>>>>>
>>>>> It has been reported by multiple users across a handful of distros
>>>>> that
>>>>> there seems to be regression on Framework laptop (which presumably
>>>>> is not
>>>>> that special in terms of mobo and display)
>>>>>
>>>>> Ref:
>>>>> https://community.frame.work/t/psa-dont-upgrade-to-linux-kernel-5-19-12-arch1-1-on-arch-linux-gen-11-model/23171
>>>> Can anyone do a 'git bisect' to find the offending commit?
>>> Also, this works for me on a gen 12 framework laptop:
>>>     $ uname -a
>>>     Linux frame 5.19.12 #68 SMP PREEMPT_DYNAMIC Fri Sep 30 07:02:33
>>> CEST 2022 x86_64 GNU/Linux
>>>
>>> so there's something odd with the older hardware?
>>>
>>> greg k-h
>> Could be. Running git bisect for 5.19.11 and 5.19.12 (as suggested by
>> the linked forum thread) returned nothing on gen 11 for me.
>>
>> This is very odd,
>> -srw
> 
> 
