Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF44125796
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 00:16:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbfLRXQa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Dec 2019 18:16:30 -0500
Received: from mga14.intel.com ([192.55.52.115]:40402 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726518AbfLRXQa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Dec 2019 18:16:30 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Dec 2019 15:16:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,330,1571727600"; 
   d="scan'208";a="228051246"
Received: from jtreacy-mobl1.ger.corp.intel.com ([10.251.82.127])
  by orsmga002.jf.intel.com with ESMTP; 18 Dec 2019 15:16:25 -0800
Message-ID: <b31c7eca8be9922f47a176f5a6ec5de030b713a5.camel@linux.intel.com>
Subject: Re: [PATCH v2] tpm_tis: reserve chip for duration of
 tpm_tis_core_init
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Jerry Snitselaar <jsnitsel@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christian Bundy <christianbundy@fraction.io>,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>, linux-integrity@vger.kernel.org
In-Reply-To: <20191217172612.5hxyt7w3wtbrkypm@cantor>
References: <20191211231758.22263-1-jsnitsel@redhat.com>
         <20191211235455.24424-1-jsnitsel@redhat.com>
         <5aef0fbe28ed23b963c53d61445b0bac6f108642.camel@linux.intel.com>
         <CAPcyv4h60z889bfbiwvVhsj6MxmOPiPY8ZuPB_skxkZx-N+OGw@mail.gmail.com>
         <20191217020022.knh7uxt4pn77wk5m@cantor>
         <CAPcyv4iepQup4bwMuWzq6r5gdx83hgYckUWFF7yF=rszjz3dtQ@mail.gmail.com>
         <5d0763334def7d7ae1e7cf931ef9b14184dce238.camel@linux.intel.com>
         <20191217171844.huqlj5csr262zkkk@cantor>
         <20191217172612.5hxyt7w3wtbrkypm@cantor>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160
 Espoo
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Date:   Thu, 19 Dec 2019 01:09:52 +0200
User-Agent: Evolution 3.34.1-2 
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2019-12-17 at 10:26 -0700, Jerry Snitselaar wrote:
> It appears he is out of the office until January, so I doubt I will hear
> anything back until then.

Unless we have access to a platform to sanely validate a fix
before that, we will have to wait until January then.

/Jarkko

