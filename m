Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B10EF9BEB8
	for <lists+stable@lfdr.de>; Sat, 24 Aug 2019 18:13:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727146AbfHXQNM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Aug 2019 12:13:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:43956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726604AbfHXQNM (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 24 Aug 2019 12:13:12 -0400
Received: from localhost (unknown [40.117.208.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 10ECC21897
        for <stable@vger.kernel.org>; Sat, 24 Aug 2019 16:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566663192;
        bh=frcCV1k9oG9oKj3dpUqdJg1PxRT2RSN/XKdLCPjaYaY=; h=From:Date:From;
        b=dKVtYq6deAfjXBjutwgGpVGJl2jYqR0xIBJxcojHAKGhlD7f8Bv5o/lH3Oa/p4uCM
         s6UHd4MKkPjXHlzPmBMrXJJzpHuBwdat/dy44V4oIAgfxX8IbnTtky86QB3F8rnshp
         FETK8ah+Z4IKO/rpUElS/iy5hNjrK8giJZZ+Asgw=
From:   Sasha Levin <sashal@kernel.org>
Date:   Sat, 24 Aug 2019 16:13:11 +0000
Message-Id: <20190824161312.10ECC21897@mail.kernel.org>
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

