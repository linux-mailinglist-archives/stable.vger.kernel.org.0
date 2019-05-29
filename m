Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A2EE2DA26
	for <lists+stable@lfdr.de>; Wed, 29 May 2019 12:13:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbfE2KNV convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 29 May 2019 06:13:21 -0400
Received: from ZXSHCAS2.zhaoxin.com ([203.148.12.82]:58568 "EHLO
        ZXSHCAS2.zhaoxin.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726024AbfE2KNV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 May 2019 06:13:21 -0400
X-Greylist: delayed 903 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 May 2019 06:13:20 EDT
Received: from zxbjmbx2.zhaoxin.com (10.29.252.164) by ZXSHCAS2.zhaoxin.com
 (10.28.252.162) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1261.35; Wed, 29 May
 2019 17:58:09 +0800
Received: from zxbjmbx1.zhaoxin.com (10.29.252.163) by zxbjmbx2.zhaoxin.com
 (10.29.252.164) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1261.35; Wed, 29 May
 2019 17:58:08 +0800
Received: from zxbjmbx1.zhaoxin.com ([fe80::b41a:737:a784:b70d]) by
 zxbjmbx1.zhaoxin.com ([fe80::b41a:737:a784:b70d%16]) with mapi id
 15.01.1261.035; Wed, 29 May 2019 17:58:08 +0800
From:   Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>
To:     "tipbot@zytor.com" <tipbot@zytor.com>
CC:     "ashok.raj@intel.com" <ashok.raj@intel.com>,
        "bp@suse.de" <bp@suse.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tip-commits@vger.kernel.org" 
        <linux-tip-commits@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        David Wang <DavidWang@zhaoxin.com>
Subject: Re: [tip:x86/urgent] x86/mce: Ensure offline CPUs don' t participate
 in rendezvous process
Thread-Topic: Re: [tip:x86/urgent] x86/mce: Ensure offline CPUs don' t
 participate in rendezvous process
Thread-Index: AdUV/LHofhz829fxQm+1FlrtATZuKw==
Date:   Wed, 29 May 2019 09:58:08 +0000
Message-ID: <ff0c714d200c487fac15da7e4003c1b4@zhaoxin.com>
Accept-Language: en-US, zh-CN
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.32.64.23]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,
	This patch requires all #MC exception errors set MCG_STATUS_RIPV = 1?
Because on offline CPUs, for #MC exception errors set MCG_STATUS_RIPV = 0
(like "Recoverable-not-continuable SRAR Type" Errors), this patch doesn't seem
to work. if this patch's "return; " in a wrong place?

Thanks
Tony W Wang-oc
