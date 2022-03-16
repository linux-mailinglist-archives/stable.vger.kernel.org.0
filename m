Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D00EB4DB38D
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 15:43:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349287AbiCPOoe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 10:44:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356818AbiCPOo2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 10:44:28 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C7CD013E23;
        Wed, 16 Mar 2022 07:43:14 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8DBC81476;
        Wed, 16 Mar 2022 07:43:14 -0700 (PDT)
Received: from [192.168.178.6] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id ABA793F766;
        Wed, 16 Mar 2022 07:43:11 -0700 (PDT)
Message-ID: <fc0d66cb-a8f8-578c-61ae-c45c167ab55a@arm.com>
Date:   Wed, 16 Mar 2022 15:42:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3] topology: make core_mask include at least
 cluster_siblings
Content-Language: en-US
To:     Darren Hart <darren@os.amperecomputing.com>
Cc:     Vincent Guittot <vincent.guittot@linaro.org>,
        Will Deacon <will@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Arm <linux-arm-kernel@lists.infradead.org>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Barry Song <song.bao.hua@hisilicon.com>,
        Valentin Schneider <Valentin.Schneider@arm.com>,
        "D . Scott Phillips" <scott@os.amperecomputing.com>,
        Ilkka Koskinen <ilkka@os.amperecomputing.com>,
        stable@vger.kernel.org
References: <f1deaeabfd31fdf512ff6502f38186ef842c2b1f.1646413117.git.darren@os.amperecomputing.com>
 <20220308103012.GA31267@willie-the-truck>
 <CAKfTPtDe+i0fwV10m2sX2xkJGBrO8B+RQogDDij8ioJAT5+wAw@mail.gmail.com>
 <e91bcc83-37c8-dcca-e088-8b3fcd737b2c@arm.com> <YieXQD7uG0+R5QBq@fedora>
 <7ac47c67-0b5e-5caa-20bb-a0100a0cb78f@arm.com> <YijxUAuufpBKLtwy@fedora>
 <35344252-5284-b08e-fec7-6dc99476b4b0@arm.com> <Yi9zuL8RZyYu1dVL@fedora>
From:   Dietmar Eggemann <dietmar.eggemann@arm.com>
In-Reply-To: <Yi9zuL8RZyYu1dVL@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 14/03/2022 17:56, Darren Hart wrote:
> On Mon, Mar 14, 2022 at 10:37:21AM +0100, Dietmar Eggemann wrote:
>> On 09/03/2022 19:26, Darren Hart wrote:
>>> On Wed, Mar 09, 2022 at 01:50:07PM +0100, Dietmar Eggemann wrote:
>>>> On 08/03/2022 18:49, Darren Hart wrote:
>>>>> On Tue, Mar 08, 2022 at 05:03:07PM +0100, Dietmar Eggemann wrote:
>>>>>> On 08/03/2022 12:04, Vincent Guittot wrote:
>>>>>>> On Tue, 8 Mar 2022 at 11:30, Will Deacon <will@kernel.org> wrote:

[...]

>>> Thank you, I'm following internally and will get with you.
>>
>> Looks like in my PPTT, the `Processor Hierarchy Nodes` which represents
>> cluster nodes have no valid `ACPI Processor ID`.
> 
> Thanks, I'm looking for the right person to get us the latest information
> available this. Will follow up once I have.

We're installing the new FW on our machine right now. Should see the CLS
SD level w/o hacking find_acpi_cpu_topology_cluster() then ;-)
