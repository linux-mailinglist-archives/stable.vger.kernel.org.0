Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81D169C525
	for <lists+stable@lfdr.de>; Sun, 25 Aug 2019 19:33:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728645AbfHYRdn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Aug 2019 13:33:43 -0400
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:39897 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725971AbfHYRdn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 25 Aug 2019 13:33:43 -0400
Received: from xps13 ([83.160.161.190])
        by smtp-cloud7.xs4all.net with ESMTPSA
        id 1wOWi1kpFThuu1wOZix6bZ; Sun, 25 Aug 2019 19:33:41 +0200
Message-ID: <dd3a1ec7d03888dade78db1e4c45ec1347c0815b.camel@tiscali.nl>
Subject: Re: Linux 5.2.10
From:   Paul Bolle <pebolle@tiscali.nl>
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, akpm@linux-foundation.org
Cc:     jslaby@suse.cz, lwn@lwn.net
Date:   Sun, 25 Aug 2019 19:33:36 +0200
In-Reply-To: <20190825144703.6518-1-sashal@kernel.org>
References: <20190825144703.6518-1-sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfN42HIq+T3e6Uv/dme3AG85mTGT+JGuflqMTtz8RstCz+SUKfVyH8XVdG0FXfkAryY22SyVhHtjulJ79HbQDNe1awwJLteU8Y7LgtSsSPfLXbMgMLpMr
 dgFYqzbuSXKMhe9vwA9WY8kLcI+r58Sko2XPfQ58bIiDF+ZfuwkM8bEXlAYTA8uFwiT6iI2+5h63KEt6VHtL9ZXWb6cDC4zdmHf5ceiYaTroGdeXSgsNZH/v
 crvnRkoCdz1TpplAHdpGY6fWxkBYP/QKf4kmBciEgfCB4saYsEMvTnVliLkleDSQ6GRt3W6W8HiJCXbETaBtPQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sasha,

Sasha Levin schreef op zo 25-08-2019 om 10:47 [-0400]:
> I'm announcing the release of the 5.2.10 kernel.
> 
> All users of the 5.2 kernel series must upgrade.
> 
> The updated 5.2.y git tree can be found at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.2.y
> and can be browsed at the normal kernel.org git web browser:
>         https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

v5.2.10 was tagged by sashal@kernel.org but signed by 
alexander.levin@verizon.com. Perhaps you could use one of gpg2's many options
to add an
    aka "Sasha Levin <sashal@kernel.org>"

line to that key. (I assume "--recv-key" then would have found your key.)

Or would that be a sin against kernel.org policy, state-of-the-art
cryptographic practices, or whatever?

Thanks,


Paul Bolle

