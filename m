Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B20C1E693
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 03:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726190AbfEOBRb convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 14 May 2019 21:17:31 -0400
Received: from mga09.intel.com ([134.134.136.24]:41975 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726148AbfEOBRa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 May 2019 21:17:30 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 May 2019 18:17:29 -0700
X-ExtLoop1: 1
Received: from orsmsx110.amr.corp.intel.com ([10.22.240.8])
  by orsmga002.jf.intel.com with ESMTP; 14 May 2019 18:17:29 -0700
Received: from orsmsx157.amr.corp.intel.com (10.22.240.23) by
 ORSMSX110.amr.corp.intel.com (10.22.240.8) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Tue, 14 May 2019 18:17:29 -0700
Received: from orsmsx121.amr.corp.intel.com ([169.254.10.47]) by
 ORSMSX157.amr.corp.intel.com ([169.254.9.37]) with mapi id 14.03.0415.000;
 Tue, 14 May 2019 18:17:29 -0700
From:   "Schmauss, Erik" <erik.schmauss@intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: Possible mis-backport of 4abb951b in 4.19.35 ("ACPICA: AML
 interpreter: add region addresses...")
Thread-Topic: Possible mis-backport of 4abb951b in 4.19.35 ("ACPICA: AML
 interpreter: add region addresses...")
Thread-Index: AQHVA3sHg6huTCc9j0i77n2Wgo9sv6ZePXSAgA0zAMA=
Date:   Wed, 15 May 2019 01:17:28 +0000
Message-ID: <CF6A88132359CE47947DB4C6E1709ED53C5CF0B6@ORSMSX121.amr.corp.intel.com>
References: <20190505194448.GA2649@windriver.com>
 <20190506084145.GA23991@kroah.com>
In-Reply-To: <20190506084145.GA23991@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiYmJmZWVmYTItZWUxMS00NDQwLTkzZmItOWYyYzc1ZDc3NWYzIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiK2ZnbEE4dm5wZmdQOERKSzJaRm5zdVJ2YjlWQTF4U3pTMVVIb3FtV1wvUjRCRUxDT0RiT1wvUG5Qc1hIRHBORTl1In0=
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.0.600.7
dlp-reaction: no-action
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> -----Original Message-----
> From: Greg Kroah-Hartman [mailto:gregkh@linuxfoundation.org]
> Sent: Monday, May 6, 2019 1:42 AM
> To: Paul Gortmaker <paul.gortmaker@windriver.com>; Wysocki, Rafael J
> <rafael.j.wysocki@intel.com>
> Cc: stable@vger.kernel.org; Schmauss, Erik <erik.schmauss@intel.com>
> Subject: Re: Possible mis-backport of 4abb951b in 4.19.35 ("ACPICA: AML
> interpreter: add region addresses...")
> 
> On Sun, May 05, 2019 at 03:44:48PM -0400, Paul Gortmaker wrote:
> > I noticed 4.19.35 got a backport of mainline 4abb951b, but it appears
> > to be a duplicate backport that landed in the wrong function.  We can
> > see this in the stable-queue repo:
> >
> > stable-queue$ find . -name '*acpica-aml-interpreter-add-region-addr*'
> > |grep 4.19
> > ./releases/4.19.6/acpica-aml-interpreter-add-region-addresses-in-globa
> > l-list-during-initialization.patch
> > ./releases/4.19.3/revert-acpica-aml-interpreter-add-region-addresses-i
> > n.patch
> > ./releases/4.19.35/acpica-aml-interpreter-add-region-addresses-in-glob
> > al-list-during-initialization.patch
> > ./releases/4.19.2/acpica-aml-interpreter-add-region-addresses-in-globa
> > l-list-during-initialization.patch
> >
> > So it was added to 4.19.2, reverted in .3, re-added in .6, and then
> > finally patched into a similar looking but wrong function in .35
> >
> > If we diff the .6 and .35 versions, we see the function difference:
> >
> > -@@ -417,6 +417,10 @@ acpi_ds_eval_region_operands(struct acpi
> > +@@ -523,6 +523,10 @@ acpi_ds_eval_table_region_operands(struc
> >
> > I don't know what the history is/was around the 2/3/6 churn, but the
> > re-addition in 4.19.35 to a different function sure looks wrong.
> >
> > The commit adds a call "status = acpi_ut_add_address_range(..." and if
> > we check mainline, there is only one in that file, but in 4.19.35+
> > there now are two calls - since the two functions had similar context
> > and comments, it isn't hard to see how patch could/would apply it a
> > 2nd time in the wrong place.
> >
> > I didn't check if any of the other currently maintained linux-stable
> > versions also had this possible issue.
> >
> 
Hi Greg,

> Ugh, Rafael, did I mess this up again?  Can you check to see if I need to fix this
> somehow?

It should be called in acpi_ds_eval_region_operands rather than acpi_ds_eval_table_region_operands.
Please remove the call from acpi_ds_eval_table_region_operands.

Thanks,
Erik
> 
> thanks,
> 
> greg k-h
