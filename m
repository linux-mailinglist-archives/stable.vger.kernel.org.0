Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 453EDE91B4
	for <lists+stable@lfdr.de>; Tue, 29 Oct 2019 22:19:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728567AbfJ2VTj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 29 Oct 2019 17:19:39 -0400
Received: from mga07.intel.com ([134.134.136.100]:45831 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727041AbfJ2VTj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Oct 2019 17:19:39 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Oct 2019 14:19:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,245,1569308400"; 
   d="scan'208";a="230215688"
Received: from fmsmsx108.amr.corp.intel.com ([10.18.124.206])
  by fmsmga002.fm.intel.com with ESMTP; 29 Oct 2019 14:19:36 -0700
Received: from fmsmsx155.amr.corp.intel.com (10.18.116.71) by
 FMSMSX108.amr.corp.intel.com (10.18.124.206) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 29 Oct 2019 14:19:36 -0700
Received: from fmsmsx120.amr.corp.intel.com ([169.254.15.63]) by
 FMSMSX155.amr.corp.intel.com ([169.254.5.15]) with mapi id 14.03.0439.000;
 Tue, 29 Oct 2019 14:19:35 -0700
From:   "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>,
        "Dalessandro, Dennis" <dennis.dalessandro@intel.com>
CC:     "dledford@redhat.com" <dledford@redhat.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "Wan, Kaike" <kaike.wan@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Erwin, James" <james.erwin@intel.com>
Subject: RE: [PATCH for-rc 1/4] IB/hfi1: Allow for all speeds higher than
 gen3
Thread-Topic: [PATCH for-rc 1/4] IB/hfi1: Allow for all speeds higher than
 gen3
Thread-Index: AQHVi26R/0lyV/3sa0qeVr5XnHCm8adygzMA//+iA+A=
Date:   Tue, 29 Oct 2019 21:19:34 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC729594E1@fmsmsx120.amr.corp.intel.com>
References: <20191025161717.106825.14421.stgit@awfm-01.aw.intel.com>
 <20191025195823.106825.63080.stgit@awfm-01.aw.intel.com>
 <20191029195214.GA1802@ziepe.ca>
In-Reply-To: <20191029195214.GA1802@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNWViNGUzOTQtNGUxZS00NzRjLWExOTYtNTJjYTFhYjE4Y2E4IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiYndwVStURmF6YkF4MGxcL1dwbzVoelBMZDNQUFNDZ1c2QklZUGJLNjFJV1pqUktHM0ZMUjhWeFBpRXBPZU55MXAifQ==
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.1.200.107]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> Subject: Re: [PATCH for-rc 1/4] IB/hfi1: Allow for all speeds higher than gen3
> 
> On Fri, Oct 25, 2019 at 03:58:24PM -0400, Dennis Dalessandro wrote:
> > From: James Erwin <james.erwin@intel.com>
> >
> > The driver avoids the gen3 speed bump when the parent
> > bus speed isn't identical to gen3, 8.0GT/s.  This is not
> > compatible with gen4 and newer speeds.
> >
> > Fix by relaxing the test to explicitly look for the lower
> > capability speeds which inherently allows for all future speeds.
> 
> This description does not seem like stable material to me.
> 

Having a card unknowingly operate at half speed would seem pretty serious to me.

Perhaps the description should say:

IB/hfi1: Insure full Gen3 speed in a Gen4 system

Mike
