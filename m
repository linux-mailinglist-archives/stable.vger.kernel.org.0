Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 697E819C6D8
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 18:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389392AbgDBQP7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 12:15:59 -0400
Received: from verein.lst.de ([213.95.11.211]:49119 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389294AbgDBQP7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Apr 2020 12:15:59 -0400
Received: by verein.lst.de (Postfix, from userid 2005)
        id 9EE5368B05; Thu,  2 Apr 2020 18:15:57 +0200 (CEST)
Date:   Thu, 2 Apr 2020 18:15:57 +0200
From:   Torsten Duwe <duwe@lst.de>
To:     stable@vger.kernel.org
Subject: drm/bridge: analogix-anx6345: Avoid duplicate -supply suffix
Message-ID: <20200402161557.GA15916@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sorry, I forgot the "fixes:" in commit 

6726ca1a2d531f5a6efc1f785b15606ce837c4dc

I was hoping DRM maintainers would pick it up before it hit mainline,
but it hasn't happened.

Please apply to 5.6.x

The driver is new in 5.6 and this fix is merged for 5.7 already.

Sorry for the inconvenience,

	Torsten

