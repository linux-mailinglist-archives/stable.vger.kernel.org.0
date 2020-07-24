Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32EAE22C5F8
	for <lists+stable@lfdr.de>; Fri, 24 Jul 2020 15:13:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726493AbgGXNNo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jul 2020 09:13:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:37304 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726182AbgGXNNo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jul 2020 09:13:44 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 679B3AC46;
        Fri, 24 Jul 2020 13:13:51 +0000 (UTC)
Subject: Re: [PATCH v2 2/4] xen/balloon: make the balloon wait interruptible
To:     Roger Pau Monne <roger.pau@citrix.com>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        xen-devel@lists.xenproject.org
References: <20200724124241.48208-1-roger.pau@citrix.com>
 <20200724124241.48208-3-roger.pau@citrix.com>
From:   =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Message-ID: <57d403c1-5df4-d4cf-3faa-2aae2ba1faa1@suse.com>
Date:   Fri, 24 Jul 2020 15:13:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200724124241.48208-3-roger.pau@citrix.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 24.07.20 14:42, Roger Pau Monne wrote:
> So it can be killed, or else processes can get hung indefinitely
> waiting for balloon pages.
> 
> Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>

Reviewed-by: Juergen Gross <jgross@suse.com>


Juergen

