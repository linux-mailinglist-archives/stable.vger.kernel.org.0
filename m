Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD53012577C
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 00:12:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726730AbfLRXMQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Dec 2019 18:12:16 -0500
Received: from mga11.intel.com ([192.55.52.93]:45849 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726561AbfLRXMQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Dec 2019 18:12:16 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Dec 2019 15:12:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,330,1571727600"; 
   d="scan'208";a="267021915"
Received: from jtreacy-mobl1.ger.corp.intel.com ([10.251.82.127])
  by FMSMGA003.fm.intel.com with ESMTP; 18 Dec 2019 15:12:12 -0800
Message-ID: <76b080f8db89a75cc238c5e1e08c4e7104df3300.camel@linux.intel.com>
Subject: Re: [PATCH v2] tpm_tis: reserve chip for duration of
 tpm_tis_core_init
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Jerry Snitselaar <jsnitsel@redhat.com>
Cc:     Dan Williams <dan.j.williams@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christian Bundy <christianbundy@fraction.io>,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>, linux-integrity@vger.kernel.org
Date:   Thu, 19 Dec 2019 01:12:11 +0200
In-Reply-To: <20191217202920.kktuk3q3qrnuvscd@cantor>
References: <20191211231758.22263-1-jsnitsel@redhat.com>
         <20191211235455.24424-1-jsnitsel@redhat.com>
         <5aef0fbe28ed23b963c53d61445b0bac6f108642.camel@linux.intel.com>
         <CAPcyv4h60z889bfbiwvVhsj6MxmOPiPY8ZuPB_skxkZx-N+OGw@mail.gmail.com>
         <20191217020022.knh7uxt4pn77wk5m@cantor>
         <CAPcyv4iepQup4bwMuWzq6r5gdx83hgYckUWFF7yF=rszjz3dtQ@mail.gmail.com>
         <5d0763334def7d7ae1e7cf931ef9b14184dce238.camel@linux.intel.com>
         <20191217202920.kktuk3q3qrnuvscd@cantor>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2019-12-17 at 13:29 -0700, Jerry Snitselaar wrote:
> I just heard back from the t490s user, and as expected the problem still exists
> there with this patch.

OK. Now we have to reason what still is behaving incorrectly
and create a proper fix. Is he available to test a subsequent
fix?

Since the holidays are coming it might anyway take early Jan
before we can test anything but we can still try to find the
root cause by inspection.

/Jarkko

