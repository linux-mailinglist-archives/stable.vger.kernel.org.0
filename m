Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 164371FA166
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 22:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729692AbgFOUZA convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 15 Jun 2020 16:25:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:27877 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728346AbgFOUZA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jun 2020 16:25:00 -0400
IronPort-SDR: FF5O2tkpqGQA7JYMoW20ZWPcpxmwanSP59MbDWx8F/NwoeVexrbXqd7IaZXl1ePFrIoQ++35+4
 1RKsRXGNJNFQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2020 13:24:59 -0700
IronPort-SDR: 7N9t9KzsH/ks2ucGsS5IshxutQAHc2Ds7rXZC+ei1U2NRxrOTth5mutDh5hkJum/H0bQcvNv3d
 x85hTYXGlu6w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,516,1583222400"; 
   d="scan'208";a="449533041"
Received: from orsmsx102.amr.corp.intel.com ([10.22.225.129])
  by orsmga005.jf.intel.com with ESMTP; 15 Jun 2020 13:24:59 -0700
Received: from orsmsx157.amr.corp.intel.com (10.22.240.23) by
 ORSMSX102.amr.corp.intel.com (10.22.225.129) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 15 Jun 2020 13:24:59 -0700
Received: from orsmsx115.amr.corp.intel.com ([169.254.4.56]) by
 ORSMSX157.amr.corp.intel.com ([169.254.9.197]) with mapi id 14.03.0439.000;
 Mon, 15 Jun 2020 13:24:58 -0700
From:   "Luck, Tony" <tony.luck@intel.com>
To:     Sasha Levin <sashal@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "bp@suse.de" <bp@suse.de>, "juew@google.com" <juew@google.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Subject: RE: FAILED: patch "[PATCH] x86/{mce,mm}: Unmap the entire page if
 the whole page is" failed to apply to 5.7-stable tree
Thread-Topic: FAILED: patch "[PATCH] x86/{mce,mm}: Unmap the entire page if
 the whole page is" failed to apply to 5.7-stable tree
Thread-Index: AQHWQyXBSx9FvQtjiE6jGf4+i7LSYqjalEmA//+K3tA=
Date:   Mon, 15 Jun 2020 20:24:58 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F7F66C7E9@ORSMSX115.amr.corp.intel.com>
References: <1592233210137106@kroah.com> <20200615202157.GB1931@sasha-vm>
In-Reply-To: <20200615202157.GB1931@sasha-vm>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

>>  [ bp: Adjust to x86/entry changes. ]
>
> We need to "unadjust" it for the stable branches, and I dare not do it
> myself :)
>
> Would picking up the original version from the mailing list work here as
> a backport?

I posted versions to stable@vger.kernel.org based on the original earlier
today. 5.6 & 5.7 applied cleanly. 5.4 and 4.19 needed another small tweak.

-Tony
