Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59FEE54D060
	for <lists+stable@lfdr.de>; Wed, 15 Jun 2022 19:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344042AbiFORun (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jun 2022 13:50:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358002AbiFORul (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jun 2022 13:50:41 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5356541B7
        for <stable@vger.kernel.org>; Wed, 15 Jun 2022 10:50:35 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id gc3-20020a17090b310300b001e33092c737so2723758pjb.3
        for <stable@vger.kernel.org>; Wed, 15 Jun 2022 10:50:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=QfCF2UsmU1Pniv5Pf4uVgOiwJRRieSBYhaM8CMSmQ3U=;
        b=Pdshfu1RKVhPNis08umwmUUzhrIzuI1qOJCBow86aXNtlNrNUkQkaCWDO89gmAgj6v
         PoUjEwLg6MO5uM5qbb4DM5WmtipAbO4F/NrF7yjVysoPoGDCANnsAlG5f8A4TIkPgAnr
         ZX3rmGkJHMi0g1gmWoEXhtwYVEJdKAmVAGmT2pgQ+WjgZnFJRHc9Uy0zkzI3K9PMma7K
         MXuDZ3DtadPA/iculyZSRPJxHQXMg9lvYR/nSaej8PqYXcPEhFS1othMR7b1sJxvqbQX
         KbkApuBpzlgRt7lA3TmFwIM+PaXj7jNMYGyv2PiJT5fl3fLOFlr5cvnyf7FinSFNGMcu
         K2hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=QfCF2UsmU1Pniv5Pf4uVgOiwJRRieSBYhaM8CMSmQ3U=;
        b=Xsty1T9E8YhBUm02aMfURjnEc+Wp+OG4+TQN+gRFWl07NG6c/DXMfT8+MlzoQIL/06
         qPTkbUTN/I+oCjzeT47KOqkfViLQgKHbzuhxx0xJDqzWrkbfaCpgy4ngXIlcsIYrwueM
         XkyqCQig2dEpMasLTA6FwS5pUovCMt0OeTDk/geOtP2vQkX+aBoKcsVQ4TIfiDc8aW++
         +uipfi91wxwLWUL/wbIz16r4xxLFVTwFnVcnO9aJtJyAgM5dqT0RryoaufhyoS/5tHsX
         O21l1HeGKgo9S2pCoQ9wnV1iqujnKpmPjA3Bz8/VVbvvzFbN3lC93N0GHTmHzgqC68Uu
         nYtg==
X-Gm-Message-State: AJIora8QKpINqBqVAHkWdkuvoBwFcltPC1nq8iLYxWj0S9yt14o6GABQ
        64W6t7KKIqD2WLx+G0jAKYw=
X-Google-Smtp-Source: AGRyM1tuUWVOE9TzgSzU74eaIcQ/ZeNW5GN0XVRmVm0PRdEBUdPkL2L0CmPF+4r9OP3XWrBQYluWYQ==
X-Received: by 2002:a17:90b:3654:b0:1ea:4540:d32 with SMTP id nh20-20020a17090b365400b001ea45400d32mr11452858pjb.92.1655315435252;
        Wed, 15 Jun 2022 10:50:35 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h13-20020a17090a3d0d00b001ea5d9ae7d9sm2067433pjc.40.2022.06.15.10.50.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jun 2022 10:50:34 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <50eeff2e-45c5-5eb2-c41d-3e0092a84483@roeck-us.net>
Date:   Wed, 15 Jun 2022 10:50:32 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 5.4 26/34] dm verity: set DM_TARGET_IMMUTABLE feature flag
Content-Language: en-US
To:     Mike Snitzer <snitzer@kernel.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>, keescook@chromium.org,
        sarthakkukreti@google.com, stable@vger.kernel.org,
        Oleksandr Tymoshenko <ovt@google.com>, dm-devel@redhat.com,
        regressions@lists.linux.dev
References: <20220603173816.944766454@linuxfoundation.org>
 <20220610042200.2561917-1-ovt@google.com> <YqLTV+5Q72/jBeOG@kroah.com>
 <YqNfBMOR9SE2TuCm@redhat.com> <Yqb/sT205Lrhl6Bv@kroah.com>
 <20220615143642.GA2386944@roeck-us.net> <Yqn64AMwoIzQXwXM@redhat.com>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <Yqn64AMwoIzQXwXM@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/15/22 08:29, Mike Snitzer wrote:
> On Wed, Jun 15 2022 at 10:36P -0400,
> Guenter Roeck <linux@roeck-us.net> wrote:
> 
>> On Mon, Jun 13, 2022 at 11:13:21AM +0200, Greg KH wrote:
>>> On Fri, Jun 10, 2022 at 11:11:00AM -0400, Mike Snitzer wrote:
>>>> On Fri, Jun 10 2022 at  1:15P -0400,
>>>> Greg KH <gregkh@linuxfoundation.org> wrote:
>>>>
>>>>> On Fri, Jun 10, 2022 at 04:22:00AM +0000, Oleksandr Tymoshenko wrote:
>>>>>> I believe this commit introduced a regression in dm verity on systems
>>>>>> where data device is an NVME one. Loading table fails with the
>>>>>> following diagnostics:
>>>>>>
>>>>>> device-mapper: table: table load rejected: including non-request-stackable devices
>>>>>>
>>>>>> The same kernel works with the same data drive on the SCSI interface.
>>>>>> NVME-backed dm verity works with just this commit reverted.
>>>>>>
>>>>>> I believe the presence of the immutable partition is used as an indicator
>>>>>> of special case NVME configuration and if the data device's name starts
>>>>>> with "nvme" the code tries to switch the target type to
>>>>>> DM_TYPE_NVME_BIO_BASED (drivers/md/dm-table.c lines 1003-1010).
>>>>>>
>>>>>> The special NVME optimization case was removed in
>>>>>> 5.10 by commit 9c37de297f6590937f95a28bec1b7ac68a38618f, so only 5.4 is
>>>>>> affected.
>>>>>>
>>>>>
>>>>> Why wouldn't 4.9, 4.14, and 4.19 also be affected here?  Should I also
>>>>> just queue up 9c37de297f65 ("dm: remove special-casing of bio-based
>>>>> immutable singleton target on NVMe") to those older kernels?  If so,
>>>>> have you tested this and verified that it worked?
>>>>
>>>> Sorry for the unforeseen stable@ troubles here!
>>>>
>>>> In general we'd be fine to apply commit 9c37de297f65 but to do it
>>>> properly would require also making sure commits that remove
>>>> "DM_TYPE_NVME_BIO_BASED", like 8d47e65948dd ("dm mpath: remove
>>>> unnecessary NVMe branching in favor of scsi_dh checks") are applied --
>>>> basically any lingering references to DM_TYPE_NVME_BIO_BASED need to
>>>> be removed.
>>>>
>>>> The commit header for 8d47e65948dd documents what
>>>> DM_TYPE_NVME_BIO_BASED was used for.. it was dm-mpath specific and
>>>> "nvme" mode really never got used by any userspace that I'm aware of.
>>>>
>>>> Sadly I currently don't have the time to do this backport for all N
>>>> stable kernels... :(
>>>>
>>>> But if that backport gets out of control: A simpler, albeit stable@
>>>> unicorn, way to resolve this is to simply revert 9c37de297f65 and make
>>
>> 9c37de297f65 can not be reverted in 5.4 and older because it isn't there,
>> and trying to apply it results in conflicts which at least I can not
>> resolve.
>>
>>>> it so that DM-mpath and DM core just used bio-based if "nvme" is
>>>> requested by dm-mpath, so also in drivers/md/dm-mpath.c e.g.:
>>>>
>>>> @@ -1091,8 +1088,6 @@ static int parse_features(struct dm_arg_set *as, struct multipath *m)
>>>>
>>>>                          if (!strcasecmp(queue_mode_name, "bio"))
>>>>                                  m->queue_mode = DM_TYPE_BIO_BASED;
>>>> 			else if (!strcasecmp(queue_mode_name, "nvme"))
>>>> -                               m->queue_mode = DM_TYPE_NVME_BIO_BASED;
>>>> +                               m->queue_mode = DM_TYPE_BIO_BASED;
>>>>                          else if (!strcasecmp(queue_mode_name, "rq"))
>>>>                                  m->queue_mode = DM_TYPE_REQUEST_BASED;
>>>>                          else if (!strcasecmp(queue_mode_name, "mq"))
>>>>
>>>> Mike
>>>>
>>>
>>> Ok, please submit a working patch for the kernels that need it so that
>>> we can review and apply it to solve this regression.
>>>
>>
>> So, effectively, v5.4.y and older are broken right now for use cases
>> with dm on NVME drives.
>>
>> Given that the regression does affect older branches, and given that we
>> have to revert this patch to avoid regressions in ChromeOS, would it be
>> possible to revert it from v5.4.y and older until a fix is found ?
> 
> I obviously would prefer to not have this false-start.
> 
The false start has already happened since we had to revert the patch
from chromeos-5.4 and older branches.

Guenter
