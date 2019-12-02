Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80CF710EF73
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 19:44:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727857AbfLBSny (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 13:43:54 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:49879 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727783AbfLBSny (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Dec 2019 13:43:54 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id C9E4722331;
        Mon,  2 Dec 2019 13:43:52 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 02 Dec 2019 13:43:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=KF+LOK7Oz3IVzefSc8lu98RYXJR
        KzI5ErcAOrK2J5A0=; b=XrAoYtFk4dG1UaDZH5jbx+GA56OEGL2NHVPSlRXZgnD
        HId39wMAic68P1ivRJjuHAOOey8v/L4jWlfj9I6Ers/8O7AwkqtbrCC5Q6p2Ouq3
        S+5oT8HNtJBVT6RkuJgz1lQZ26Gl55D4TEflCFDPjjW0eAL6+q4nLpXVubHZjSwe
        zZw5Q6v3ZSJnW0hyB391D6Gk52F7bbm93xu+/Yukvlgdx/4ybqqwWQ5PSHF19L/x
        KAwtoT7KBv74E/PZOeEyIkNIPwix08JdijA9097ejO0WwpJquMk/rnWmiLaJmFrG
        PFi+/Y14aUtkmYSu/myyRHMFpQSHjOzs+pKqa20r+1Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=KF+LOK
        7Oz3IVzefSc8lu98RYXJRKzI5ErcAOrK2J5A0=; b=gPhBsGiCQuJIGYHEqB348u
        ClkZMj4FFUhFB7Zz+fA3ZgUL5hi8x01D02A9fIyYQwOpGDH6JUK9USpiDXiq7/+k
        8qK31k9cc7SqKM8tAQaLYYJjso5MdkvDpXAGkPDEEdlFeIA8XfT3i9WAXgVdi2kE
        5GoJ40Kb1+9GejtvA5EIP4SO5uvNz1ajvRhCbesz+6YeftW6IFAdfr0mFZ7mpLGa
        QlK3/JNuBfdRbYdcxfXmjh/ID6IMkNJkY5LmVIQmYsVV/MmaQuy5cR05A8seB+c0
        opoBxSoXM84m28HEzf536umzhywY+xb8D/qBpAK1kvJKXWJdYlzjHXm633WoTXCQ
        ==
X-ME-Sender: <xms:aFvlXelWZxd61iy3KT_1RkcceG7Yl9QLHtsVr5bcwpyoHNy4eQmYdA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudejhedguddukecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:aFvlXWp7_e7d_6iPiMoCOcJGmMdNjbhX8q3onbgoGwA0OKfunxVL4w>
    <xmx:aFvlXbMIz9aDQurGmZGRZPqKv3OYOcPwiOimqbINK8vZwJ9sCVmyPg>
    <xmx:aFvlXYayhCh3RGmiI7LI_jZkDywtnzqfy1VDHOM-3AegPkCA67ee-A>
    <xmx:aFvlXQyflayerK7ZZ62SchT0sltSq8ObvTINqsgCSAgROLrnvX4RtA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5B60730600BD;
        Mon,  2 Dec 2019 13:43:52 -0500 (EST)
Date:   Mon, 2 Dec 2019 19:43:49 +0100
From:   Greg KH <greg@kroah.com>
To:     Sven Van Asbroeck <thesven73@gmail.com>
Cc:     Sebastian Reichel <sre@kernel.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable <stable@vger.kernel.org>
Subject: Re: [PATCH 4.4 v1] power: supply: ltc2941-battery-gauge: fix
 use-after-free
Message-ID: <20191202184349.GC734264@kroah.com>
References: <20190919151137.9960-1-TheSven73@gmail.com>
 <20190919190208.13648-1-TheSven73@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190919190208.13648-1-TheSven73@gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 19, 2019 at 03:02:08PM -0400, Sven Van Asbroeck wrote:
> This driver's remove path calls cancel_delayed_work().
> However, that function does not wait until the work function
> finishes. This could mean that the work function is still
> running after the driver's remove function has finished,
> which would result in a use-after-free.
> 
> Fix by calling cancel_delayed_work_sync(), which ensures that
> that the work is properly cancelled, no longer running, and
> unable to re-schedule itself.
> 
> This issue was detected with the help of Coccinelle.
> 
> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: Sven Van Asbroeck <TheSven73@gmail.com>
> ---
>  drivers/power/ltc2941-battery-gauge.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/power/ltc2941-battery-gauge.c b/drivers/power/ltc2941-battery-gauge.c
> index da49436176cd..30a9014b2f95 100644
> --- a/drivers/power/ltc2941-battery-gauge.c
> +++ b/drivers/power/ltc2941-battery-gauge.c
> @@ -449,7 +449,7 @@ static int ltc294x_i2c_remove(struct i2c_client *client)
>  {
>  	struct ltc294x_info *info = i2c_get_clientdata(client);
>  
> -	cancel_delayed_work(&info->work);
> +	cancel_delayed_work_sync(&info->work);
>  	power_supply_unregister(info->supply);
>  	return 0;
>  }
> -- 
> 2.17.1
> 

What is the git commit id of this patch in Linus's tree?

thanks,

greg k-h
