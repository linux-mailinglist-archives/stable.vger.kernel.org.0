Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE97300472
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 14:45:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727883AbhAVNou (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 08:44:50 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:36117 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727877AbhAVNot (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jan 2021 08:44:49 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 9092519C2157;
        Fri, 22 Jan 2021 08:44:02 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 22 Jan 2021 08:44:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=VoJoN+
        DexloJ1kmmlG1YpL/7WJy8iFqzls7jMZrN2/g=; b=edkY3bmGCz316q3ooSRVFn
        QPA1VL5sCiKMtMt3gLYrZRcO/qOD/n1LRyDSs4forcER+ydr+GRA6Vg4JEnVZUkk
        RXuqBNrWNnt6+4wSLEeHW02iRYtg2j6w9+4fsUAAkkhgcpY8FLPmWpZA3rwLsmIE
        +tqqOvik8AL6i0kuhTiI6KuTpBii0GPNJcxvXUA7eJlZcBThDCvHFkYzU7/rOy1E
        WJ49VjTstejwLvo6x3Mq6Z6PPQsD8HSY/WRl0pJTKsU+IYQxLXDA7r+hkjrXYdqW
        LIEaT51GI9j5pcutXlF7G8msnbCJURcR8D/hOS8hAbQfSdn4UNnU33ez+lZ8xL0Q
        ==
X-ME-Sender: <xms:otYKYFqLl7hs8wD2bTOEI8xboLAaumqZkyRnMj_XvKmCVo1s-415MQ>
    <xme:otYKYHpNp4o7VtPb2CKsMcvh4StSsvydmWHw7JiGNkUVygO9J4EdHPXhr66puu0dB
    A_CE6KhfYC6eA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudeigdeitdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:otYKYCPxr4iYqiSd5zDDXlEsqns67GeDFzJZfVmS65b3g26hUezu6w>
    <xmx:otYKYA6KtjCsuWh-mYyK3kuA95uA18K0MdOwBI_A8VbqEUInbPgmfQ>
    <xmx:otYKYE4g7WIWa-An9hB7NAPHVZJmpRAuDE1t7kOjm4k9IGTbMdrjJA>
    <xmx:otYKYEGpsuHUcKky09QNoti3_fPWj2fi6kmp__fdmJm3PdSoLYCVLA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 04142240065;
        Fri, 22 Jan 2021 08:44:01 -0500 (EST)
Subject: FAILED: patch "[PATCH] net/mlx5e: Modify uplink state on interface up/down" failed to apply to 5.10-stable tree
To:     rondi@mellanox.com, moshe@mellanox.com, roid@mellanox.com,
        saeedm@mellanox.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 22 Jan 2021 14:43:52 +0100
Message-ID: <161132303258146@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 7d0314b11cdd92bca8b89684c06953bf114605fc Mon Sep 17 00:00:00 2001
From: Ron Diskin <rondi@mellanox.com>
Date: Sun, 5 Apr 2020 13:58:40 +0300
Subject: [PATCH] net/mlx5e: Modify uplink state on interface up/down

When setting the PF interface up/down, notify the firmware to update
uplink state via MODIFY_VPORT_STATE, when E-Switch is enabled.

This behavior will prevent sending traffic out on uplink port when PF is
down, such as sending traffic from a VF interface which is still up.
Currently when calling mlx5e_open/close(), the driver only sends PAOS
command to notify the firmware to set the physical port state to
up/down, however, it is not sufficient. When VF is in "auto" state, it
follows the uplink state, which was not updated on mlx5e_open/close()
before this patch.

When switchdev mode is enabled and uplink representor is first enabled,
set the uplink port state value back to its FW default "AUTO".

Fixes: 63bfd399de55 ("net/mlx5e: Send PAOS command on interface up/down")
Signed-off-by: Ron Diskin <rondi@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 31f9ecae98df..07fdbea7ea13 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3069,6 +3069,25 @@ void mlx5e_timestamp_init(struct mlx5e_priv *priv)
 	priv->tstamp.rx_filter = HWTSTAMP_FILTER_NONE;
 }
 
+static void mlx5e_modify_admin_state(struct mlx5_core_dev *mdev,
+				     enum mlx5_port_status state)
+{
+	struct mlx5_eswitch *esw = mdev->priv.eswitch;
+	int vport_admin_state;
+
+	mlx5_set_port_admin_status(mdev, state);
+
+	if (!MLX5_ESWITCH_MANAGER(mdev) ||  mlx5_eswitch_mode(esw) == MLX5_ESWITCH_OFFLOADS)
+		return;
+
+	if (state == MLX5_PORT_UP)
+		vport_admin_state = MLX5_VPORT_ADMIN_STATE_AUTO;
+	else
+		vport_admin_state = MLX5_VPORT_ADMIN_STATE_DOWN;
+
+	mlx5_eswitch_set_vport_state(esw, MLX5_VPORT_UPLINK, vport_admin_state);
+}
+
 int mlx5e_open_locked(struct net_device *netdev)
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
@@ -3101,7 +3120,7 @@ int mlx5e_open(struct net_device *netdev)
 	mutex_lock(&priv->state_lock);
 	err = mlx5e_open_locked(netdev);
 	if (!err)
-		mlx5_set_port_admin_status(priv->mdev, MLX5_PORT_UP);
+		mlx5e_modify_admin_state(priv->mdev, MLX5_PORT_UP);
 	mutex_unlock(&priv->state_lock);
 
 	return err;
@@ -3135,7 +3154,7 @@ int mlx5e_close(struct net_device *netdev)
 		return -ENODEV;
 
 	mutex_lock(&priv->state_lock);
-	mlx5_set_port_admin_status(priv->mdev, MLX5_PORT_DOWN);
+	mlx5e_modify_admin_state(priv->mdev, MLX5_PORT_DOWN);
 	err = mlx5e_close_locked(netdev);
 	mutex_unlock(&priv->state_lock);
 
@@ -5182,7 +5201,7 @@ static void mlx5e_nic_enable(struct mlx5e_priv *priv)
 
 	/* Marking the link as currently not needed by the Driver */
 	if (!netif_running(netdev))
-		mlx5_set_port_admin_status(mdev, MLX5_PORT_DOWN);
+		mlx5e_modify_admin_state(mdev, MLX5_PORT_DOWN);
 
 	mlx5e_set_netdev_mtu_boundaries(priv);
 	mlx5e_set_dev_port_mtu(priv);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 8c294ab43f90..9519a61bd8ec 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1081,6 +1081,8 @@ static void mlx5e_uplink_rep_enable(struct mlx5e_priv *priv)
 
 	mlx5e_rep_tc_enable(priv);
 
+	mlx5_modify_vport_admin_state(mdev, MLX5_VPORT_STATE_OP_MOD_UPLINK,
+				      0, 0, MLX5_VPORT_ADMIN_STATE_AUTO);
 	mlx5_lag_add(mdev, netdev);
 	priv->events_nb.notifier_call = uplink_rep_async_event;
 	mlx5_notifier_register(mdev, &priv->events_nb);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index d9376627584e..71d01143c455 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1826,6 +1826,8 @@ int mlx5_eswitch_set_vport_state(struct mlx5_eswitch *esw,
 				 u16 vport, int link_state)
 {
 	struct mlx5_vport *evport = mlx5_eswitch_get_vport(esw, vport);
+	int opmod = MLX5_VPORT_STATE_OP_MOD_ESW_VPORT;
+	int other_vport = 1;
 	int err = 0;
 
 	if (!ESW_ALLOWED(esw))
@@ -1833,15 +1835,17 @@ int mlx5_eswitch_set_vport_state(struct mlx5_eswitch *esw,
 	if (IS_ERR(evport))
 		return PTR_ERR(evport);
 
+	if (vport == MLX5_VPORT_UPLINK) {
+		opmod = MLX5_VPORT_STATE_OP_MOD_UPLINK;
+		other_vport = 0;
+		vport = 0;
+	}
 	mutex_lock(&esw->state_lock);
 
-	err = mlx5_modify_vport_admin_state(esw->dev,
-					    MLX5_VPORT_STATE_OP_MOD_ESW_VPORT,
-					    vport, 1, link_state);
+	err = mlx5_modify_vport_admin_state(esw->dev, opmod, vport, other_vport, link_state);
 	if (err) {
-		mlx5_core_warn(esw->dev,
-			       "Failed to set vport %d link state, err = %d",
-			       vport, err);
+		mlx5_core_warn(esw->dev, "Failed to set vport %d link state, opmod = %d, err = %d",
+			       vport, opmod, err);
 		goto unlock;
 	}
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index a5175e98c0b3..5785596f13f5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -680,6 +680,8 @@ static inline int mlx5_eswitch_enable(struct mlx5_eswitch *esw, int num_vfs) { r
 static inline void mlx5_eswitch_disable(struct mlx5_eswitch *esw, bool clear_vf) {}
 static inline bool mlx5_esw_lag_prereq(struct mlx5_core_dev *dev0, struct mlx5_core_dev *dev1) { return true; }
 static inline bool mlx5_eswitch_is_funcs_handler(struct mlx5_core_dev *dev) { return false; }
+static inline
+int mlx5_eswitch_set_vport_state(struct mlx5_eswitch *esw, u16 vport, int link_state) { return 0; }
 static inline const u32 *mlx5_esw_query_functions(struct mlx5_core_dev *dev)
 {
 	return ERR_PTR(-EOPNOTSUPP);
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 073b79eacc99..1340e02b14ef 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -4381,6 +4381,7 @@ struct mlx5_ifc_query_vport_state_out_bits {
 enum {
 	MLX5_VPORT_STATE_OP_MOD_VNIC_VPORT  = 0x0,
 	MLX5_VPORT_STATE_OP_MOD_ESW_VPORT   = 0x1,
+	MLX5_VPORT_STATE_OP_MOD_UPLINK      = 0x2,
 };
 
 struct mlx5_ifc_arm_monitor_counter_in_bits {

