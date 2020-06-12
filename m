Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42D371F7701
	for <lists+stable@lfdr.de>; Fri, 12 Jun 2020 13:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725886AbgFLLAX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 12 Jun 2020 07:00:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:52164 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725805AbgFLLAW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jun 2020 07:00:22 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CA2CFAD87;
        Fri, 12 Jun 2020 11:00:24 +0000 (UTC)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Namjae Jeon <namjae.jeon@samsung.com>, linux-cifs@vger.kernel.org
Cc:     linkinjeon@kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Stable <stable@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Subject: Re: [PATCH] smb3: add indatalen that can be a non-zero value to
 calculation of credit charge in smb2 ioctl
In-Reply-To: <20200611022119.31506-1-namjae.jeon@samsung.com>
References: <CGME20200611022619epcas1p46fd9d1d54396f0a4206b550949377d99@epcas1p4.samsung.com>
 <20200611022119.31506-1-namjae.jeon@samsung.com>
Date:   Fri, 12 Jun 2020 13:00:19 +0200
Message-ID: <87ftb0im64.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Namjae,

Nice to see a patch :)

Reviewed-by: Aurelien Aptel <aaptel@suse.com>

Cheers,
-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg, DE
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah HRB 247165 (AG München)
