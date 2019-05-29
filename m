Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED2872DBB3
	for <lists+stable@lfdr.de>; Wed, 29 May 2019 13:22:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725948AbfE2LWV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 07:22:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:44228 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725894AbfE2LWV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 07:22:21 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3D9E9AF8C;
        Wed, 29 May 2019 11:22:20 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id B399BDA85E; Wed, 29 May 2019 13:23:14 +0200 (CEST)
Date:   Wed, 29 May 2019 13:23:14 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
Subject: Please revert "btrfs: Honour FITRIM range constraints during free
 space trim" from all stable trees
Message-ID: <20190529112314.GY15290@suse.cz>
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

upon closer inspection we found a problem with the patch

"btrfs: Honour FITRIM range constraints during free space trim"

that has been merged to 5.1.4. This could happen with ranged FITRIM
where the range is not 'honoured' as it was supposed to.

Please revert it and push in the next stable release so the buggy
version is not in the wild for too long.

Affected trees:

5.0.18
5.1.4
4.9.179
4.19.45
4.14.122

Master branch will have the revert too. Thanks.
