Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3B7B239F82
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 08:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbgHCGSq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 02:18:46 -0400
Received: from mx2.suse.de ([195.135.220.15]:60750 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726190AbgHCGSq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 02:18:46 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id C0078AF38;
        Mon,  3 Aug 2020 06:18:59 +0000 (UTC)
Subject: Re: [PATCH v3 2/4] xen/balloon: make the balloon wait interruptible
To:     Roger Pau Monne <roger.pau@citrix.com>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        xen-devel@lists.xenproject.org
References: <20200727091342.52325-1-roger.pau@citrix.com>
 <20200727091342.52325-3-roger.pau@citrix.com>
From:   =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Message-ID: <65a4575a-d3ed-3aca-3f30-60eab3792346@suse.com>
Date:   Mon, 3 Aug 2020 08:18:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200727091342.52325-3-roger.pau@citrix.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 27.07.20 11:13, Roger Pau Monne wrote:
> So it can be killed, or else processes can get hung indefinitely
> waiting for balloon pages.
> 
> Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
> Reviewed-by: Juergen Gross <jgross@suse.com>
> Cc: stable@vger.kernel.org

Pushed to: xen/tip.git for-linus-5.9


Juergen
