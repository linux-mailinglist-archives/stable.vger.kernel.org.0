Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60BBA103C73
	for <lists+stable@lfdr.de>; Wed, 20 Nov 2019 14:44:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729758AbfKTNoi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Nov 2019 08:44:38 -0500
Received: from mga04.intel.com ([192.55.52.120]:18835 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729025AbfKTNoi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Nov 2019 08:44:38 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Nov 2019 05:44:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,222,1571727600"; 
   d="scan'208";a="196856611"
Received: from um.fi.intel.com (HELO um) ([10.237.72.57])
  by orsmga007.jf.intel.com with ESMTP; 20 Nov 2019 05:44:35 -0800
From:   Alexander Shishkin <alexander.shishkin@linux.intel.com>
To:     Wen Yang <wenyang@linux.alibaba.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        stable@vger.kernel.org, alexander.shishkin@linux.intel.com
Subject: Re: [GIT PULL 1/3] intel_th: Fix a double put_device() in error path
In-Reply-To: <2e648871-b7f7-c77e-6a22-3c26ad90633b@linux.alibaba.com>
References: <20191120130806.44028-1-alexander.shishkin@linux.intel.com> <20191120130806.44028-2-alexander.shishkin@linux.intel.com> <2e648871-b7f7-c77e-6a22-3c26ad90633b@linux.alibaba.com>
Date:   Wed, 20 Nov 2019 15:44:34 +0200
Message-ID: <87sgmid5ml.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Wen Yang <wenyang@linux.alibaba.com> writes:

> device_add() has increased the reference count,
>
> so when it returns an error, an additional call to put_device()
>
> is needed here to reduce the reference count.

No, in case of error it also drops its reference.

Regards,
--
Alex
