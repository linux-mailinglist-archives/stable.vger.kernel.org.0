Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 140B9EA4A1
	for <lists+stable@lfdr.de>; Wed, 30 Oct 2019 21:15:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbfJ3UO7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 30 Oct 2019 16:14:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:2657 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726261AbfJ3UO7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Oct 2019 16:14:59 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Oct 2019 13:14:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,248,1569308400"; 
   d="scan'208";a="205886970"
Received: from fmsmsx107.amr.corp.intel.com ([10.18.124.205])
  by FMSMGA003.fm.intel.com with ESMTP; 30 Oct 2019 13:14:58 -0700
Received: from fmsmsx121.amr.corp.intel.com (10.18.125.36) by
 fmsmsx107.amr.corp.intel.com (10.18.124.205) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 30 Oct 2019 13:14:58 -0700
Received: from fmsmsx120.amr.corp.intel.com ([169.254.15.63]) by
 fmsmsx121.amr.corp.intel.com ([169.254.6.22]) with mapi id 14.03.0439.000;
 Wed, 30 Oct 2019 13:14:58 -0700
From:   "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
CC:     "Dalessandro, Dennis" <dennis.dalessandro@intel.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "Wan, Kaike" <kaike.wan@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Erwin, James" <james.erwin@intel.com>
Subject: RE: [PATCH for-rc 1/4] IB/hfi1: Allow for all speeds higher than
 gen3
Thread-Topic: [PATCH for-rc 1/4] IB/hfi1: Allow for all speeds higher than
 gen3
Thread-Index: AQHVi26R/0lyV/3sa0qeVr5XnHCm8adygzMA//+iA+CAAdMsAP//rXJQ
Date:   Wed, 30 Oct 2019 20:14:57 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC7295AE50@fmsmsx120.amr.corp.intel.com>
References: <20191025161717.106825.14421.stgit@awfm-01.aw.intel.com>
 <20191025195823.106825.63080.stgit@awfm-01.aw.intel.com>
 <20191029195214.GA1802@ziepe.ca>
 <32E1700B9017364D9B60AED9960492BC729594E1@fmsmsx120.amr.corp.intel.com>
 <20191030180754.GA31799@ziepe.ca>
In-Reply-To: <20191030180754.GA31799@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiZmFiMjM1Y2MtMmE4NC00ZjUzLWE0NDItNzE5ZTQ0NmU2YmY2IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiKzhKaFdBNDVDMHlGUUszc2E1bUZ6SnBIaHhGbngreVdKZHNFQkdEanZyODd6VVIyc3pqejFyYkorQXRYYkVSOSJ9
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.1.200.108]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> 
> Since gen4 systems are really new this also sounds like a new feature
> to me.. You need to be concerned that changing the pci setup doesn't
> cause regressions on existing systems too.
> 

We have covered this with all of our types of cards and servers (gen3 and gen4).

> > Perhaps the description should say:
> >
> > IB/hfi1: Insure full Gen3 speed in a Gen4 system
> 
> And maybe explain what the actual user visible impact is here. Sounds
> like plugging a card into a gen4 system will not run at gen3 speeds?
> 

Ok.   I will reissue the patch some changes in the commit message.

Mike
