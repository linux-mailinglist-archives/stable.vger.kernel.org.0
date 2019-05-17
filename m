Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E33E821F73
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 23:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727035AbfEQVPx convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 17 May 2019 17:15:53 -0400
Received: from mga05.intel.com ([192.55.52.43]:57761 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726771AbfEQVPw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 May 2019 17:15:52 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 May 2019 14:15:52 -0700
X-ExtLoop1: 1
Received: from orsmsx101.amr.corp.intel.com ([10.22.225.128])
  by FMSMGA003.fm.intel.com with ESMTP; 17 May 2019 14:15:52 -0700
Received: from orsmsx121.amr.corp.intel.com ([169.254.10.47]) by
 ORSMSX101.amr.corp.intel.com ([169.254.8.107]) with mapi id 14.03.0415.000;
 Fri, 17 May 2019 14:15:52 -0700
From:   "Schmauss, Erik" <erik.schmauss@intel.com>
To:     Sasha Levin <sashal@kernel.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>
Subject: RE: Possible mis-backport of 4abb951b in 4.19.35 ("ACPICA: AML
 interpreter: add region addresses...")
Thread-Topic: Possible mis-backport of 4abb951b in 4.19.35 ("ACPICA: AML
 interpreter: add region addresses...")
Thread-Index: AQHVA3sHg6huTCc9j0i77n2Wgo9sv6ZePXSAgA0zAMCAALM+gIABDBMA///KRSCAAgnbgIAA38CA
Date:   Fri, 17 May 2019 21:15:51 +0000
Message-ID: <CF6A88132359CE47947DB4C6E1709ED53C5D27E0@ORSMSX121.amr.corp.intel.com>
References: <20190505194448.GA2649@windriver.com>
 <20190506084145.GA23991@kroah.com>
 <CF6A88132359CE47947DB4C6E1709ED53C5CF0B6@ORSMSX121.amr.corp.intel.com>
 <20190515045711.GA16452@kroah.com>
 <f2110cb8-8d80-65df-55a9-5428e6e4e9c3@intel.com>
 <CF6A88132359CE47947DB4C6E1709ED53C5D0845@ORSMSX121.amr.corp.intel.com>
 <20190517005209.GZ11972@sasha-vm>
In-Reply-To: <20190517005209.GZ11972@sasha-vm>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiMzY0OTgzMjYtYjFhZi00NmQ1LWIxNzctYTNlYTAyZDlmZTY1IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiNTVOQ29yR1RhWjRVZVV4Z0NjR2R2Vm9kNFhcL0Z5TnFDWisxV0pcL1B2RkF4cFwvcWxiZE1IeE9VMU4zbE5XT0RBTiJ9
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.0.600.7
dlp-reaction: no-action
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> -----Original Message-----
> From: Sasha Levin [mailto:sashal@kernel.org]
> Sent: Thursday, May 16, 2019 5:52 PM
> To: Schmauss, Erik <erik.schmauss@intel.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>; Paul Gortmaker
> <paul.gortmaker@windriver.com>; stable@vger.kernel.org; Wysocki, Rafael
> J <rafael.j.wysocki@intel.com>
> Subject: Re: Possible mis-backport of 4abb951b in 4.19.35 ("ACPICA: AML
> interpreter: add region addresses...")
> 
> On Thu, May 16, 2019 at 12:45:54AM +0000, Schmauss, Erik wrote:
> >
> >
> >> -----Original Message-----
> >> From: Wysocki, Rafael J
> >> Sent: Wednesday, May 15, 2019 1:57 PM
> >> To: Schmauss, Erik <erik.schmauss@intel.com>
> >> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>; Paul Gortmaker
> >> <paul.gortmaker@windriver.com>; stable@vger.kernel.org
> >> Subject: Re: Possible mis-backport of 4abb951b in 4.19.35 ("ACPICA:
> >> AML
> >> interpreter: add region addresses...")
> >>
> >> On 5/15/2019 6:57 AM, Greg Kroah-Hartman wrote:
> >> > On Wed, May 15, 2019 at 01:17:28AM +0000, Schmauss, Erik wrote:
> >> >>
> >> >>> -----Original Message-----
> >> >>> From: Greg Kroah-Hartman [mailto:gregkh@linuxfoundation.org]
> >> >>> Sent: Monday, May 6, 2019 1:42 AM
> >> >>> To: Paul Gortmaker <paul.gortmaker@windriver.com>; Wysocki,
> >> >>> Rafael J <rafael.j.wysocki@intel.com>
> >> >>> Cc: stable@vger.kernel.org; Schmauss, Erik
> >> >>> <erik.schmauss@intel.com>
> >> >>> Subject: Re: Possible mis-backport of 4abb951b in 4.19.35 ("ACPICA:
> >> >>> AML
> >> >>> interpreter: add region addresses...")
> >> >>>
> >> >>> On Sun, May 05, 2019 at 03:44:48PM -0400, Paul Gortmaker wrote:
> >> >>>> I noticed 4.19.35 got a backport of mainline 4abb951b, but it
> >> >>>> appears to be a duplicate backport that landed in the wrong
> >> >>>> function.  We can see this in the stable-queue repo:
> >> >>>>
> >> >>>> stable-queue$ find . -name '*acpica-aml-interpreter-add-region-
> addr*'
> >> >>>> |grep 4.19
> >> >>>> ./releases/4.19.6/acpica-aml-interpreter-add-region-addresses-in
> >> >>>> -gl
> >> >>>> oba
> >> >>>> l-list-during-initialization.patch
> >> >>>> ./releases/4.19.3/revert-acpica-aml-interpreter-add-region-addre
> >> >>>> sse
> >> >>>> s-i
> >> >>>> n.patch
> >> >>>> ./releases/4.19.35/acpica-aml-interpreter-add-region-addresses-i
> >> >>>> n-g lob al-list-during-initialization.patch
> >> >>>> ./releases/4.19.2/acpica-aml-interpreter-add-region-addresses-in
> >> >>>> -gl
> >> >>>> oba
> >> >>>> l-list-during-initialization.patch
> >> >>>>
> >> >>>> So it was added to 4.19.2, reverted in .3, re-added in .6, and
> >> >>>> then finally patched into a similar looking but wrong function
> >> >>>> in .35
> >> >>>>
> >> >>>> If we diff the .6 and .35 versions, we see the function difference:
> >> >>>>
> >> >>>> -@@ -417,6 +417,10 @@ acpi_ds_eval_region_operands(struct acpi
> >> >>>> +@@ -523,6 +523,10 @@
> acpi_ds_eval_table_region_operands(struc
> >> >>>>
> >> >>>> I don't know what the history is/was around the 2/3/6 churn, but
> >> >>>> the re-addition in 4.19.35 to a different function sure looks wrong.
> >> >>>>
> >> >>>> The commit adds a call "status = acpi_ut_add_address_range(..."
> >> >>>> and if we check mainline, there is only one in that file, but in
> >> >>>> 4.19.35+ there now are two calls - since the two functions had
> >> >>>> similar context and comments, it isn't hard to see how patch
> >> >>>> could/would apply it a 2nd time in the wrong place.
> >> >>>>
> >> >>>> I didn't check if any of the other currently maintained
> >> >>>> linux-stable versions also had this possible issue.
> >> >>>>
> >> >> Hi Greg,
> >> >>
> >> >>> Ugh, Rafael, did I mess this up again?  Can you check to see if I
> >> >>> need to fix this somehow?
> >> >> It should be called in acpi_ds_eval_region_operands rather than
> >> acpi_ds_eval_table_region_operands.
> >> >> Please remove the call from acpi_ds_eval_table_region_operands.
> >> > Great, can someone please send me a patch for this so that I don't
> >> > get it wrong myself?
> >>
> >> Erik, can you please cut a patch for that against 4.19.35 and send it to
> Greg?
> >>
> >
> >I'm not sure what the process is for this case but here's the patch...
> >Let me know if you need me to send it some other way...
> >
> >From a738f1c452c0762d3c0a1b1a9a12c78bd97b0a23 Mon Sep 17 00:00:00
> 2001
> >From: Erik Schmauss <erik.schmauss@intel.com>
> >Date: Wed, 15 May 2019 17:25:31 -0700
> >Subject: [PATCH] Revert "ACPICA: AML interpreter: add region addresses
> >in  global list during initialization"
> >
> >This reverts commit f8053df634d40c733f26ca49c2c3835002e61b77 that was
> >unintentionally included as a part of the stable branch.
> 
> So to clarify, we're now just going to revert it? It's not needed in -stable?
Yes, we're going to revert a commit that got added by accident to the 4.19.y branch.
It may not apply to all stable branches because the reverted commit might not exist in all stable branches.

I hope this helps,

Erik
> 
> --
> Thanks,
> Sasha
