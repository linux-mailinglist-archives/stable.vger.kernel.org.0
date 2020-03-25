Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50363191E5B
	for <lists+stable@lfdr.de>; Wed, 25 Mar 2020 02:02:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727272AbgCYBCD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 21:02:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:60750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727113AbgCYBCC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 21:02:02 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE8B62076F;
        Wed, 25 Mar 2020 01:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585098122;
        bh=dA2liOY9i13O/h2d0NwNX8/L6qtxij1o43WAlUPZH3A=;
        h=Date:From:To:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:
         From;
        b=H6XRY8tp1pw2ForOtrJ6q8fo2iYiyJPu8JKD9hvWiIuc5T+5lmj/MotqTVG3hUb6N
         /S9ttdtfeimXSUtOGR/9rYb9/yXs2Wn8eif/nQk+BSoWWkbqTQvfvydi2IkHxwD+mu
         3NSambF4nFCA40Kt8fdwoSOdkf+4Q3qlNOey9nEg=
Date:   Wed, 25 Mar 2020 01:02:01 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Tomas Winkler <tomas.winkler@intel.com>
To:     Alexander Usyskin <alexander.usyskin@intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Alexander Usyskin <alexander.usyskin@intel.com>
Cc:     <stable@vger.kernel.org>
Cc:     stable@vger.kernel.org
Subject: Re: [char-misc-next] mei: me: add cedar fork device ids
In-Reply-To: <20200324210730.17672-1-tomas.winkler@intel.com>
References: <20200324210730.17672-1-tomas.winkler@intel.com>
Message-Id: <20200325010201.DE8B62076F@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.5.11, v5.4.27, v4.19.112, v4.14.174, v4.9.217, v4.4.217.

v5.5.11: Build OK!
v5.4.27: Build OK!
v4.19.112: Build OK!
v4.14.174: Failed to apply! Possible dependencies:
    1be8624a0cbe ("mei: me: add mule creek canyon (EHL) device ids")
    4d86dfd38285 ("mei: me: add comet point (lake) LP device ids")
    559e575a8946 ("mei: me: add comet point (lake) H device ids")
    82b29b9f72af ("mei: me: add comet point V device id")
    efe814e90b98 ("mei: me: add ice lake point device id.")

v4.9.217: Failed to apply! Possible dependencies:
    1be8624a0cbe ("mei: me: add mule creek canyon (EHL) device ids")
    4d86dfd38285 ("mei: me: add comet point (lake) LP device ids")
    559e575a8946 ("mei: me: add comet point (lake) H device ids")
    82b29b9f72af ("mei: me: add comet point V device id")
    efe814e90b98 ("mei: me: add ice lake point device id.")
    f8f4aa68a8ae ("mei: me: add cannon point device ids")

v4.4.217: Failed to apply! Possible dependencies:
    1be8624a0cbe ("mei: me: add mule creek canyon (EHL) device ids")
    4d86dfd38285 ("mei: me: add comet point (lake) LP device ids")
    559e575a8946 ("mei: me: add comet point (lake) H device ids")
    82b29b9f72af ("mei: me: add comet point V device id")
    efe814e90b98 ("mei: me: add ice lake point device id.")
    f8f4aa68a8ae ("mei: me: add cannon point device ids")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
