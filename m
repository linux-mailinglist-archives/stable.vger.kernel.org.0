Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B44862EEE6
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732991AbfE3Dut convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 29 May 2019 23:50:49 -0400
Received: from ZXSHCAS1.zhaoxin.com ([203.148.12.81]:10209 "EHLO
        ZXSHCAS1.zhaoxin.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728419AbfE3Dus (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 May 2019 23:50:48 -0400
Received: from zxbjmbx2.zhaoxin.com (10.29.252.164) by ZXSHCAS1.zhaoxin.com
 (10.28.252.161) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1261.35; Thu, 30 May
 2019 11:50:39 +0800
Received: from zxbjmbx1.zhaoxin.com (10.29.252.163) by zxbjmbx2.zhaoxin.com
 (10.29.252.164) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1261.35; Thu, 30 May
 2019 11:50:39 +0800
Received: from zxbjmbx1.zhaoxin.com ([fe80::b41a:737:a784:b70d]) by
 zxbjmbx1.zhaoxin.com ([fe80::b41a:737:a784:b70d%16]) with mapi id
 15.01.1261.035; Thu, 30 May 2019 11:50:39 +0800
From:   Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>
To:     "tipbot@zytor.com" <tipbot@zytor.com>,
        "ashok.raj@intel.com" <ashok.raj@intel.com>
CC:     "bp@suse.de" <bp@suse.de>, "hpa@zytor.com" <hpa@zytor.com>,
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
Thread-Index: AdUWlGl+Ivql5y3zT0ybuVHbqcI6gA==
Date:   Thu, 30 May 2019 03:50:39 +0000
Message-ID: <036f5f6f2d8a4a768309b61540857393@zhaoxin.com>
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

Hi Ashok,
I have two questions about this patch, could you help to check:

1, for broadcast #MC exceptions, this patch seems require #MC exception errors
set MCG_STATUS_RIPV = 1. 
But for Intel CPU, some #MC exception errors set MCG_STATUS_RIPV = 0 
(like "Recoverable-not-continuable SRAR Type" Errors), for these errors
the patch doesn't seem to work, is that okay?

2, for LMCE exceptions, this patch seems require #MC exception errors
set MCG_STATUS_RIPV = 0 to make sure LMCE be handled normally even
on offline CPU. 
For LMCE errors set MCG_STAUS_RIPV = 1, the patch prevents offline CPU
handle these LMCE errors, is that okay?

Thanks
Tony W Wang-oc
