Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB994DC7C
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 23:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726100AbfFTV1j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 17:27:39 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:54399 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725906AbfFTV1j (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Jun 2019 17:27:39 -0400
Received: from callcc.thunk.org (guestnat-104-133-0-109.corp.google.com [104.133.0.109] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x5KLRR4u007652
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Jun 2019 17:27:27 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id DC7A0420484; Thu, 20 Jun 2019 17:27:26 -0400 (EDT)
Date:   Thu, 20 Jun 2019 17:27:26 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Ross Zwisler <zwisler@chromium.org>
Cc:     linux-kernel@vger.kernel.org, Ross Zwisler <zwisler@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Fletcher Woodruff <fletcherw@google.com>,
        Justin TerAvest <teravest@google.com>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 3/3] ext4: use jbd2_inode dirty range scoping
Message-ID: <20190620212726.GD4650@mit.edu>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
        Ross Zwisler <zwisler@chromium.org>, linux-kernel@vger.kernel.org,
        Ross Zwisler <zwisler@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, Fletcher Woodruff <fletcherw@google.com>,
        Justin TerAvest <teravest@google.com>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
References: <20190620151839.195506-1-zwisler@google.com>
 <20190620151839.195506-4-zwisler@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190620151839.195506-4-zwisler@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 20, 2019 at 09:18:39AM -0600, Ross Zwisler wrote:
> Use the newly introduced jbd2_inode dirty range scoping to prevent us
> from waiting forever when trying to complete a journal transaction.
> 
> Signed-off-by: Ross Zwisler <zwisler@google.com>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Cc: stable@vger.kernel.org

Applied, thanks.

					- Ted
