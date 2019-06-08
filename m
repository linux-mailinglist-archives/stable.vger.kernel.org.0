Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F274139B8E
	for <lists+stable@lfdr.de>; Sat,  8 Jun 2019 09:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726705AbfFHHuI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Jun 2019 03:50:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:50480 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726042AbfFHHuI (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Jun 2019 03:50:08 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A6976AE9E;
        Sat,  8 Jun 2019 07:50:06 +0000 (UTC)
Date:   Sat, 8 Jun 2019 09:49:59 +0200
From:   Borislav Petkov <bp@suse.de>
To:     Baoquan He <bhe@redhat.com>
Cc:     tglx@linutronix.de, stable@vger.kernel.org, mingo@kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org, peterz@infradead.org,
        keescook@chromium.org, luto@kernel.org, hpa@zytor.com,
        kirill@linux.intel.com, dave.hansen@linux.intel.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86/mm/KASLR: Compute the size of the vmemmap
 section properly
Message-ID: <20190608074959.GA31866@zn.tnic>
References: <20190523025744.3756-1-bhe@redhat.com>
 <tip-00e5a2bbcc31d5fea853f8daeba0f06c1c88c3ff@git.kernel.org>
 <20190608021404.GA26148@MiWiFi-R3L-srv>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190608021404.GA26148@MiWiFi-R3L-srv>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jun 08, 2019 at 10:14:04AM +0800, Baoquan He wrote:
> Here, 4PB = 4*2^50 = 4*1024^5, the vmemmap should be 64 TB, am I right?

PB is 1000^5 petabytes.

1024^5 is PiB or pebibytes.

https://en.wikipedia.org/wiki/Petabyte

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Mary Higgins, Sri Rasiah, HRB 21284 (AG Nürnberg)
-- 
