Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E493D10B03B
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 14:33:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbfK0Nd7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 27 Nov 2019 08:33:59 -0500
Received: from mx2.suse.de ([195.135.220.15]:50646 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726320AbfK0Nd6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 08:33:58 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 12749B1F0;
        Wed, 27 Nov 2019 13:33:54 +0000 (UTC)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     "Paulo Alcantara \(SUSE\)" <pc@cjr.nz>, smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, "Paulo Alcantara \(SUSE\)" <pc@cjr.nz>,
        stable@vger.kernel.org,
        Matthew Ruffell <matthew.ruffell@canonical.com>
Subject: Re: [PATCH v3 10/11] cifs: Fix retrieval of DFS referrals in
 cifs_mount()
In-Reply-To: <20191127003634.14072-11-pc@cjr.nz>
References: <20191127003634.14072-1-pc@cjr.nz>
 <20191127003634.14072-11-pc@cjr.nz>
Date:   Wed, 27 Nov 2019 14:33:53 +0100
Message-ID: <87pnhdtpdq.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

"Paulo Alcantara (SUSE)" <pc@cjr.nz> writes:
> Make sure that DFS referrals are sent to newly resolved root targets
> as in a multi tier DFS setup.

Reviewed-by: Aurelien Aptel <aaptel@suse.com>

-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg, DE
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah HRB 247165 (AG München)
