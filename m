Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D49DCB1DD4
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 14:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729965AbfIMMnq convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 13 Sep 2019 08:43:46 -0400
Received: from mga14.intel.com ([192.55.52.115]:34090 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726771AbfIMMnp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 08:43:45 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Sep 2019 05:43:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,492,1559545200"; 
   d="scan'208";a="187805348"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by orsmga003.jf.intel.com with ESMTP; 13 Sep 2019 05:43:44 -0700
Received: from fmsmsx162.amr.corp.intel.com (10.18.125.71) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 13 Sep 2019 05:43:44 -0700
Received: from fmsmsx120.amr.corp.intel.com ([169.254.15.9]) by
 fmsmsx162.amr.corp.intel.com ([169.254.5.238]) with mapi id 14.03.0439.000;
 Fri, 13 Sep 2019 05:43:43 -0700
From:   "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
To:     Jason Gunthorpe <jgg@mellanox.com>,
        "Dalessandro, Dennis" <dennis.dalessandro@intel.com>
CC:     "dledford@redhat.com" <dledford@redhat.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "Weiny, Ira" <ira.weiny@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Wan, Kaike" <kaike.wan@intel.com>
Subject: RE: [PATCH for-next 3/3] IB/hfi1: Define variables as unsigned long
 to fix KASAN warning
Thread-Topic: [PATCH for-next 3/3] IB/hfi1: Define variables as unsigned
 long to fix KASAN warning
Thread-Index: AQHVaJRhDW39fYtHH0mWXMwbuDsZn6cp+x8A//+U3/A=
Date:   Fri, 13 Sep 2019 12:43:43 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC70EB553C@fmsmsx120.amr.corp.intel.com>
References: <20190911112912.126040.72184.stgit@awfm-01.aw.intel.com>
 <20190911113053.126040.47327.stgit@awfm-01.aw.intel.com>
 <20190912161219.GA15092@mellanox.com>
In-Reply-To: <20190912161219.GA15092@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiZmY0YTY5NWItMjQxMS00OTNjLTg4Y2ItMjIzNTUzMDhmNGQzIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoidmMwM1d1U3dRQnl0Zlc4YmhOd1wvUDU5Z0lCcERwbEI5eFpRTzBoMEdQb3hVWVwvYnhDb3ExTjBnUU5Zbk5NRmlUIn0=
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

> > Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
> 
> This needs a fixes line, can you tell me what it is?

This is day 1 bug:

Fixes: 7724105686e7 ("IB/hfi1: add driver files")

Mike
