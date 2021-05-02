Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5C82370AFB
	for <lists+stable@lfdr.de>; Sun,  2 May 2021 11:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232135AbhEBJwQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 May 2021 05:52:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:35310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231934AbhEBJwQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 May 2021 05:52:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E8AC6121E;
        Sun,  2 May 2021 09:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619949084;
        bh=frcCV1k9oG9oKj3dpUqdJg1PxRT2RSN/XKdLCPjaYaY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s9msgRAg6SKcWiCCy2lz15MaNB8qJzvSG0IRgLjSRfQJY7zVc7SJd+ho/8vm1mSjc
         Clxs0811NEzCtg9n0kSpd9fzv/dQsbWWRxY9YffCI6KsNf2ynHU6L/WkeLHOPmBmOu
         0mIMXtYELvtubtfmP8OT82sgl7Uy6oFDEpvNNOek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.12.1
Date:   Sun,  2 May 2021 11:51:16 +0200
Message-Id: <1619949076164212@kroah.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <1619949076103205@kroah.com>
References: <1619949076103205@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

