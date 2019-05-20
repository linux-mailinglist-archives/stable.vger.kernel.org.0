Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEDD223D95
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 18:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732102AbfETQgJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 12:36:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:53678 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731223AbfETQgJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 12:36:09 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BA5BDAFC2
        for <stable@vger.kernel.org>; Mon, 20 May 2019 16:36:08 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 40576DA86C; Mon, 20 May 2019 18:37:05 +0200 (CEST)
Date:   Mon, 20 May 2019 18:37:05 +0200
From:   David Sterba <dsterba@suse.cz>
To:     stable@vger.kernel.org
Subject: Please add 10995c0491204c861 to stable 5.1.x
Message-ID: <20190520163705.GG3138@twin.jikos.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

please add 10995c0491204c861 ("btrfs: reloc: Fix NULL pointer
dereference due to expanded reloc_root lifespan") to 5.1, applies
cleanly. We got a user report of the crash that this patch fixes.

Thanks.
