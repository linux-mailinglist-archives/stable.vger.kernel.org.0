Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE9DFEC92A
	for <lists+stable@lfdr.de>; Fri,  1 Nov 2019 20:39:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbfKATja convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 1 Nov 2019 15:39:30 -0400
Received: from mga04.intel.com ([192.55.52.120]:17405 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726623AbfKATj3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 Nov 2019 15:39:29 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Nov 2019 12:39:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,256,1569308400"; 
   d="scan'208";a="206487329"
Received: from fmsmsx107.amr.corp.intel.com ([10.18.124.205])
  by FMSMGA003.fm.intel.com with ESMTP; 01 Nov 2019 12:39:29 -0700
Received: from FMSMSX109.amr.corp.intel.com (10.18.116.9) by
 fmsmsx107.amr.corp.intel.com (10.18.124.205) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 1 Nov 2019 12:39:29 -0700
Received: from fmsmsx120.amr.corp.intel.com ([169.254.15.63]) by
 FMSMSX109.amr.corp.intel.com ([169.254.15.66]) with mapi id 14.03.0439.000;
 Fri, 1 Nov 2019 12:39:29 -0700
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
Thread-Index: AQHVi26R/0lyV/3sa0qeVr5XnHCm8adygzMA//+iA+CAAdMsAP//rXJQgAMbKuA=
Date:   Fri, 1 Nov 2019 19:39:29 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC7295FBA6@fmsmsx120.amr.corp.intel.com>
References: <20191025161717.106825.14421.stgit@awfm-01.aw.intel.com>
 <20191025195823.106825.63080.stgit@awfm-01.aw.intel.com>
 <20191029195214.GA1802@ziepe.ca>
 <32E1700B9017364D9B60AED9960492BC729594E1@fmsmsx120.amr.corp.intel.com>
 <20191030180754.GA31799@ziepe.ca>
 <32E1700B9017364D9B60AED9960492BC7295AE50@fmsmsx120.amr.corp.intel.com>
In-Reply-To: <32E1700B9017364D9B60AED9960492BC7295AE50@fmsmsx120.amr.corp.intel.com>
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


> 
> Ok.   I will reissue the patch some changes in the commit message.
> 
> Mike

The new patch is https://lore.kernel.org/linux-rdma/20191101192059.106248.1699.stgit@awfm-01.aw.intel.com/T/#u.

Mike
