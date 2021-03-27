Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7FD834B6D2
	for <lists+stable@lfdr.de>; Sat, 27 Mar 2021 12:26:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230322AbhC0L0m convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sat, 27 Mar 2021 07:26:42 -0400
Received: from aposti.net ([89.234.176.197]:55756 "EHLO aposti.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230288AbhC0L0m (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 27 Mar 2021 07:26:42 -0400
Date:   Sat, 27 Mar 2021 11:26:26 +0000
From:   Paul Cercueil <paul@crapouillou.net>
Subject: Re: [PATCH] drm: DON'T require each CRTC to have a unique primary
 plane
To:     Simon Ser <contact@emersion.fr>
Cc:     Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, od@zcrc.me,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Message-Id: <24LMQQ.CRNKYEI6GB2T1@crapouillou.net>
In-Reply-To: <1J_tcDPSAZW23jPO8ApyzgINcVRRWcNyFP0LvrSFVIMbZB9lH6lCWvh2ByU9rNt6bj6xpgRgv8n0hBKhXAvXNfLBGfTIsvbhYuHW3IIDd7Y=@emersion.fr>
References: <20210327112214.10252-1-paul@crapouillou.net>
        <1J_tcDPSAZW23jPO8ApyzgINcVRRWcNyFP0LvrSFVIMbZB9lH6lCWvh2ByU9rNt6bj6xpgRgv8n0hBKhXAvXNfLBGfTIsvbhYuHW3IIDd7Y=@emersion.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It has two mutually exclusive background planes (same Z level) + one 
overlay plane.

-Paul


Le sam. 27 mars 2021 à 11:24, Simon Ser <contact@emersion.fr> a écrit 
:
> On Saturday, March 27th, 2021 at 12:22 PM, Paul Cercueil 
> <paul@crapouillou.net> wrote:
> 
>>  The ingenic-drm driver has two mutually exclusive primary planes
>>  already; so the fact that a CRTC must have one and only one primary
>>  plane is an invalid assumption.
> 
> Why does this driver expose two primary planes, if it only has a 
> single
> CRTC?


