Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 634071B1413
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 20:11:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726748AbgDTSLs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 14:11:48 -0400
Received: from mx2.suse.de ([195.135.220.15]:52478 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726532AbgDTSLs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 14:11:48 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A5ADDAD39
        for <stable@vger.kernel.org>; Mon, 20 Apr 2020 18:11:46 +0000 (UTC)
Subject: Re: [PATCH v3 1/9] xen/events: avoid removing an event channel while
 handling it
To:     stable@vger.kernel.org
References: <20200417115454.24931-1-jgross@suse.com>
 <20200417115454.24931-2-jgross@suse.com>
From:   =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Message-ID: <6a36aebc-e490-52a7-f36b-f8d8b88288e2@suse.com>
Date:   Mon, 20 Apr 2020 20:11:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200417115454.24931-2-jgross@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 17.04.20 13:54, Juergen Gross wrote:
> Today it can happen that an event channel is being removed from the
> system while the event handling loop is active. This can lead to a
> race resulting in crashes or WARN() splats.
> 
> Fix this problem by using a rwlock taken as reader in the event
> handling loop and as writer when removing an event channel.
> 
> As the observed problem was a NULL dereference in evtchn_from_irq()
> make this function more robust against races by testing the irq_info
> pointer to be not NULL before dereferencing it.
> 
> Cc: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
> Cc: stable@vger.kernel.org
> Reported-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
> Signed-off-by: Juergen Gross <jgross@suse.com>

Please ignore, script went wild.


Juergen
